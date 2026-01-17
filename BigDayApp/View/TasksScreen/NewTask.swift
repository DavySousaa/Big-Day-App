import UIKit
import Foundation

protocol NewTaskDelegate: AnyObject {
    func tapCreateButton()
}

class NewTask: UIView {
    
    weak var delegate: NewTaskDelegate?
    public var saveButtonBottomConstraint: NSLayoutConstraint!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let fullText = "Crie uma nova tarefa"
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 20)!,
            .foregroundColor: UIColor.label
        ])
        label.numberOfLines = 0
        label.textAlignment = .center
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "nova tarefa")
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var newTaskTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = UIColor(named: "PrimaryColor")
        textField.layer.cornerRadius = 41/2
        textField.attributedPlaceholder = NSAttributedString(
            string: "Nome da tarefa",
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
    
    private var createTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Criar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.addTarget(self, action: #selector(methodCreatelButton), for: .touchUpInside)
        button.layer.cornerRadius = 44/2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func methodCreatelButton() {
        delegate?.tapCreateButton()
    }
    
    private var returnView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 7/2
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewTask: SetupLayout {
    func addSubViews() {
        addSubview(titleLabel)
        addSubview(hourLabel)
        addSubview(newTaskTextField)
        addSubview(timePicker)
        addSubview(createTaskButton)
        addSubview(switchPicker)
        addSubview(returnView)
    }
    
    func setupConstraints() {
        saveButtonBottomConstraint = createTaskButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        saveButtonBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            newTaskTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            newTaskTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            newTaskTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            newTaskTextField.heightAnchor.constraint(equalToConstant: 44),
            
            hourLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hourLabel.topAnchor.constraint(equalTo: newTaskTextField.bottomAnchor, constant: 20),
            
            switchPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchPicker.topAnchor.constraint(equalTo: newTaskTextField.bottomAnchor, constant: 20),
            
            timePicker.topAnchor.constraint(equalTo: switchPicker.bottomAnchor),
            timePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            timePicker.bottomAnchor.constraint(equalTo: createTaskButton.topAnchor),
            
            createTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            createTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            createTaskButton.heightAnchor.constraint(equalToConstant: 44),
            
                   
        ])
    }
    
    func setupStyle() {
        
    }
}
