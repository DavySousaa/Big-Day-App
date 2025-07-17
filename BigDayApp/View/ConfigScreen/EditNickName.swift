//
//  changeNickName.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//
import UIKit

protocol tapButtonNickNameDelete: AnyObject {
    func didTapSaveButton()
}

class EditNickName: UIView {
    
    var delegate: tapButtonNickNameDelete?
    public var saveButtonBottomConstraint: NSLayoutConstraint!

    public lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = UIColor(named: "PrimaryColor")
        textField.layer.cornerRadius = 41/2
        textField.attributedPlaceholder = NSAttributedString(
            string: "Digite aqui",
            attributes: [
                .foregroundColor: UIColor(hex: "#bebebd"),
                .font: UIFont(name: "Montserrat-Regular", size: 15)!
            ]
        )
        textField.textColor = .label
        textField.font = UIFont(name: "Montserrat-Regular", size: 15)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "SecudaryColor")
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Salvar alterações", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func didTapSaveButton() {
        print("Clicou na view")
        delegate?.didTapSaveButton()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditNickName: SetupLayout {
    func addSubViews() {
        addSubview(nickNameTextField)
        addSubview(saveButton)
    }
    
    func setupConstraints() {
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        saveButtonBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            nickNameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nickNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            nickNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 45),
            nickNameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
        
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            saveButton.heightAnchor.constraint(equalToConstant: 41),
            
        ])
    }
    
    func setupStyle() {
        
    }
}
