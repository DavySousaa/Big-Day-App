//
//  configScreen.swift
//  BigDayApp
//
//  Created by Davy Sousa on 06/07/25.
//

import UIKit

protocol tapButtonConfigDelete: AnyObject {
    func tapLogoutButton()
    func didTapEditPhoto()
    func didTapSaveButton()
    func didTapCancel()
}

class ConfigScreen: UIView {
    
    var delegate: tapButtonConfigDelete?
    
    public lazy var userPhoto: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        image.tintColor = ColorSuport.blackApp
        image.layer.cornerRadius = 60/2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    public lazy var editPhotoUser: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Editar foto", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.addTarget(self, action: #selector(didTapEditPhotoButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func didTapEditPhotoButton() {
        delegate?.didTapEditPhoto()
    }
    
    public lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#bebebd").cgColor
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 45/2
        textField.textColor = .black
        textField.font = UIFont(name: "Montserrat-Regular", size: 15)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    public lazy var autoeModeButotn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Automático", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        button.backgroundColor = .clear
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    public lazy var whiteModeButotn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Claro", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        button.backgroundColor = .clear
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    public lazy var darkModeButotn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Escuro", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        button.backgroundColor = .clear
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    private lazy var modeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [autoeModeButotn, whiteModeButotn, darkModeButotn])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Salvar alterações", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func didTapSaveButton() {
        delegate?.didTapSaveButton()
    }
    
    private var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Sair da conta", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func didTapLogoutButton() {
        delegate?.tapLogoutButton()
    }
    
    public lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        button.addTarget(self, action: #selector(didTapButtonCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonCancel(){
        delegate?.didTapCancel()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConfigScreen: SetupLayout {
    func addSubViews() {
        addSubview(userPhoto)
        addSubview(nickNameTextField)
        addSubview(saveButton)
        addSubview(modeStackView)
        addSubview(editPhotoUser)
        addSubview(logoutButton)
    }
    
    func setupConstraints() {

        NSLayoutConstraint.activate([
            userPhoto.centerXAnchor.constraint(equalTo: centerXAnchor),
            userPhoto.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            userPhoto.widthAnchor.constraint(equalToConstant: 100),
            userPhoto.heightAnchor.constraint(equalToConstant: 100),
            
            editPhotoUser.centerXAnchor.constraint(equalTo: centerXAnchor),
            editPhotoUser.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 5),
            
            nickNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            nickNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 45),
            nickNameTextField.topAnchor.constraint(equalTo: editPhotoUser.bottomAnchor, constant: 30),
            
            modeStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            modeStackView.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 15),
            modeStackView.heightAnchor.constraint(equalToConstant: 127),
            modeStackView.widthAnchor.constraint(equalToConstant: 290),
            
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
                       
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            saveButton.heightAnchor.constraint(equalToConstant: 41),
        ])
    }
    
    func setupStyle() {
        
    }
}
