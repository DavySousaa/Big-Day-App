import UIKit
import Foundation

protocol EditTaskDelegate: AnyObject {
    func tapCancelButton()
    func tapSaveButton()
}

class EditTask: UIView {
    
    weak var delegate: EditTaskDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let fullText = "O que você quer \nmudar nessa tarefa?"
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 25)!,
            .foregroundColor: UIColor.label
        ])
        
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "\nmudar nessa tarefa?")
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
    
    private lazy var repeatLabel: UILabel = {
        let label = UILabel()
        label.text = "Você deseja repetir esta tarefa?"
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var repeatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        return collectionView
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
        addSubview(titleLabel)
        addSubview(hourLabel)
        addSubview(newTaskTextField)
        addSubview(timePicker)
        addSubview(saveTaskButton)
        addSubview(repeatLabel)
        addSubview(repeatCollectionView)
        addSubview(buttonStakcView)
        addSubview(switchPicker)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            newTaskTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            newTaskTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            newTaskTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            newTaskTextField.heightAnchor.constraint(equalToConstant: 44),
            
            hourLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hourLabel.topAnchor.constraint(equalTo: newTaskTextField.bottomAnchor, constant: 25),
            
            switchPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchPicker.topAnchor.constraint(equalTo: newTaskTextField.bottomAnchor, constant: 25),
            
            timePicker.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 10),
            timePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            repeatLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10),
            repeatLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            repeatCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            repeatCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            repeatCollectionView.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 10),
            repeatCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            saveTaskButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            saveTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            saveTaskButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func setupStyle() {
        
    }
}

