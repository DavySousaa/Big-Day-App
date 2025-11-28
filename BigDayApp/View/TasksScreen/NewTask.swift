import UIKit
import Foundation

protocol NewTaskDelegate: AnyObject {
    func tapCreateButton()
}

class NewTask: UIView {
    
    weak var delegate: NewTaskDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let fullText = "Nova tarefa \npara o Big Day"
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 25)!,
            .foregroundColor: UIColor.label
        ])
        
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "\npara o Big Day")
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
        label.text = "Selecione um horário"
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
    
    private var createTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Criar tarefa", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.addTarget(self, action: #selector(methodCreatelButton), for: .touchUpInside)
        button.layer.cornerRadius = 44/2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func methodCreatelButton() {
        delegate?.tapCreateButton()
    }
    
    init() {
        super.init(frame: .zero)
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
        addSubview(repeatLabel)
        addSubview(repeatCollectionView)
        addSubview(createTaskButton)
        addSubview(switchPicker)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            newTaskTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
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
            
            createTaskButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            createTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            createTaskButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func setupStyle() {
        
    }
}

