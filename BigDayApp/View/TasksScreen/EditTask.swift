import UIKit
import Foundation

protocol EditTaskDelegate: AnyObject {
    func tapCancelButton()
    func tapSaveButton()
}

class EditTask: UIView {
    
    weak var delegate: EditTaskDelegate?
    
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
        let fullText = "Edite sua tarefa."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 18)!,
            .foregroundColor: UIColor.label
        ])
        
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "tarefa.")
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var newTaskTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 41/2
        textField.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [
                .foregroundColor: UIColor(hex: "#bebebd"),
                .font: UIFont(name: "Montserrat-Regular", size: 15)!
            ]
        )
        
        textField.textColor = .label
        textField.font = UIFont(name: "Montserrat-Regular", size: 15)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.text = "Horário"
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var switchPicker: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = ColorSuport.greenApp
        toggle.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    @objc private func switchToggled(_ sender: UISwitch) {
        timePicker.isHidden = !sender.isOn
    }
    
    public let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .clear
        picker.tintColor = .label
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var saveTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Salvar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.addTarget(self, action: #selector(methodSaveButton), for: .touchUpInside)
        button.layer.cornerRadius = 44/2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func methodSaveButton() {
        delegate?.tapSaveButton()
    }
    
    private var cancelTaskButton: UIButton = {
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
        let stack = UIStackView(arrangedSubviews: [saveTaskButton, cancelTaskButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditTask: SetupLayout {
    func addSubViews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(hourLabel)
        containerView.addSubview(newTaskTextField)
        containerView.addSubview(timePicker)
        containerView.addSubview(saveTaskButton)
        containerView.addSubview(buttonStakcView)
        containerView.addSubview(switchPicker)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 420),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            newTaskTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            newTaskTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            newTaskTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            newTaskTextField.heightAnchor.constraint(equalToConstant: 44),
            
            hourLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            hourLabel.topAnchor.constraint(equalTo: newTaskTextField.bottomAnchor, constant: 25),
            
            switchPicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            switchPicker.topAnchor.constraint(equalTo: newTaskTextField.bottomAnchor, constant: 25),
            
            timePicker.bottomAnchor.constraint(equalTo: buttonStakcView.topAnchor, constant: 10),
            timePicker.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            buttonStakcView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            buttonStakcView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStakcView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStakcView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func setupStyle() {
        
    }
}

