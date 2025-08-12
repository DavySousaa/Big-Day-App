import UIKit
import Foundation
import FSCalendar

protocol CalendarDelegate: AnyObject {
    func tapCancelButton()
    func tapSelectButton()
}

class CalendarScreen: UIView {
    
    weak var delegate: CalendarDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PrimaryColor")
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let fullText = "Escolha o dia para ser\no seu Big Day."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 18)!,
            .foregroundColor: UIColor.label
        ])
        
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "\no seu Big Day.")
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scopeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Mês","Semana"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(scopeChanged(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    @objc private func scopeChanged(_ sender: UISegmentedControl) {
        let newScope: FSCalendarScope = (sender.selectedSegmentIndex == 0) ? .month : .week
        calendar.setScope(newScope, animated: true)
    }
    
    public lazy var calendar: FSCalendar = {
        let cal = FSCalendar()
        cal.translatesAutoresizingMaskIntoConstraints = false
        cal.locale = Locale(identifier: "pt_BR")
        cal.firstWeekday = 2
        cal.scrollEnabled = true
        cal.scrollDirection = .horizontal
        cal.placeholderType = .fillHeadTail
        cal.scope = .month
        return cal
    }()
    
    private var selectDayButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Selecionar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.addTarget(self, action: #selector(methodSelectButton), for: .touchUpInside)
        button.layer.cornerRadius = 44/2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func methodSelectButton() {
        delegate?.tapSelectButton()
    }
    
    private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitleColor(ColorSuport.greenApp, for: .normal)
        button.setTitle("Cancelar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 44/2
        button.addTarget(self, action: #selector(methodCancelButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func methodCancelButton() {
        delegate?.tapCancelButton()
    }
    
    private lazy var buttonStakcView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectDayButton, cancelButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public var calendarHeightConstraint: NSLayoutConstraint!

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func styleCalendar() {
        // substitui pelas tuas cores. Ex.: ColorSuport.greenApp
        let primary = ColorSuport.greenApp
        let textPrimary = UIColor.label
        let textSecondary = UIColor.secondaryLabel

        // header (barra com mês/ano)
        calendar.appearance.headerDateFormat = "MMMM yyyy" // “agosto 2025”
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 18, weight: .semibold)
        calendar.appearance.headerTitleColor = textPrimary
        calendar.appearance.headerMinimumDissolvedAlpha = 0.3 // meses adjacentes nas setas

        // weekday (seg, ter, …)
        calendar.appearance.weekdayFont = .systemFont(ofSize: 12, weight: .semibold)
        calendar.appearance.weekdayTextColor = textSecondary
        calendar.calendarWeekdayView.weekdayLabels.forEach { $0.text = $0.text?.capitalized } // "Seg", "Ter"...

        // dia “hoje”
        calendar.appearance.todayColor = primary.withAlphaComponent(0.15)       // bolinha de hoje (fundo)
        calendar.appearance.titleTodayColor = primary                            // número do dia de hoje

        // dia selecionado
        calendar.appearance.selectionColor = primary                              // bolinha seleção
        calendar.appearance.titleSelectionColor = .white                          // número em branco
        calendar.allowsSelection = true

        // dias “normais”
        calendar.appearance.titleDefaultColor = textPrimary
        calendar.appearance.titlePlaceholderColor = textSecondary.withAlphaComponent(0.4) // dias fora do mês
        calendar.appearance.borderRadius = 0.8 // 1.0 = círculo perfeito

        // background
        calendar.backgroundColor = UIColor.secondarySystemBackground
        calendar.layer.cornerRadius = 16
        calendar.layer.masksToBounds = true

        // “event dots” (se usar pontinhos)
        calendar.appearance.eventDefaultColor = primary
        calendar.appearance.eventSelectionColor = .white
    }
}


extension CalendarScreen: SetupLayout {
    func addSubViews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(buttonStakcView)
        containerView.addSubview(scopeControl)
        containerView.addSubview(calendar)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 520),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            scopeControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            scopeControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            scopeControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            calendar.topAnchor.constraint(equalTo: scopeControl.bottomAnchor, constant: 12),
            calendar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            calendar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            
            buttonStakcView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            buttonStakcView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStakcView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStakcView.heightAnchor.constraint(equalToConstant: 44),
        ])
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 320)
        calendarHeightConstraint.isActive = true
    }
    
    func setupStyle() {
        
    }
}

