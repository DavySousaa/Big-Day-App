//
//  ForgotPassWord.swift
//  BigDayApp
//
//  Created by Davy Sousa on 14/07/25.
//

import UIKit
import Foundation

protocol ForgotPasswordDelegate: AnyObject {
    func didTapSend()
}

class ForgotPassWord: UIView {
    
    weak var delegate: ForgotPasswordDelegate?
    
    private lazy var textUp: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.textAlignment = .center
        
        let fullText = "Digite seu e-mail\npara o envio do\nlink de redefinição."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 27)!,
            .foregroundColor: UIColor.label
        ])
        
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "para o envio do\nlink de redefinição.")
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        
        text.attributedText = attributedString
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Enviar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButton(){
        delegate?.didTapSend()
    }
    
    public lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 47/2
        textField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
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
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ForgotPassWord: SetupLayout {
    func addSubViews() {
        addSubview(emailTextField)
        addSubview(textUp)
        addSubview(sendButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textUp.centerXAnchor.constraint(equalTo: centerXAnchor),
            textUp.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            
            sendButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            sendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            sendButton.heightAnchor.constraint(equalToConstant: 41),
            
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            emailTextField.heightAnchor.constraint(equalToConstant: 47),
            emailTextField.topAnchor.constraint(equalTo: textUp.bottomAnchor, constant: 30),
        ])
    }
    
    func setupStyle() {
        
    }
}



