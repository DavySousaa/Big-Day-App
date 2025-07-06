import UIKit
import Foundation

protocol LoginAccountScreenDelegate: AnyObject {
    func didTapLogin()
}

class LoginAccount: UIView {
    
    weak var delegate: LoginAccountScreenDelegate?
    
    private lazy var imageLogo: UIImageView = {
        let image = UIImageView(image: UIImage(named: "logo1"))
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var textUp: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.textAlignment = .center
        
        let fullText = "A rotina te espera.\nMas dessa vez…\ndiferente."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 27)!,
            .foregroundColor: UIColor.black
        ])
        
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "Mas dessa vez…\ndiferente.")
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        
        text.attributedText = attributedString
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Entrar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapButtonLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonLogin(){
        delegate?.didTapLogin()
    }
    
    public lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#bebebd").cgColor
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 47/2
        textField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
            attributes: [
                .foregroundColor: UIColor(hex: "#bebebd"),
                .font: UIFont(name: "Montserrat-Regular", size: 15)!
            ]
        )
        textField.textColor = .black
        textField.font = UIFont(name: "Montserrat-Regular", size: 15)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    public lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#bebebd").cgColor
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 47/2
        textField.attributedPlaceholder = NSAttributedString(
            string: "Senha",
            attributes: [
                .foregroundColor: UIColor(hex: "#bebebd"),
                .font: UIFont(name: "Montserrat-Regular", size: 15)!
            ]
        )
        textField.textColor = .black
        textField.font = UIFont(name: "Montserrat-Regular", size: 15)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.tintColor = .lightGray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        toggleButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        toggleButton.center = rightPaddingView.center
        rightPaddingView.addSubview(toggleButton)
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        return textField
        
    }()
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private lazy var stackViewLogin: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.spacing = 15
        stack.distribution = .fillEqually
        stack.axis = .vertical
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

extension LoginAccount: SetupLayout {
    func addSubViews() {
        addSubview(imageLogo)
        addSubview(textUp)
        addSubview(loginButton)
        addSubview(stackViewLogin)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageLogo.heightAnchor.constraint(equalToConstant: 44),
            imageLogo.widthAnchor.constraint(equalToConstant: 114),
            imageLogo.topAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 4),
            
            textUp.centerXAnchor.constraint(equalTo: centerXAnchor),
            textUp.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: 30),
            
            loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 41),
            
            stackViewLogin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            stackViewLogin.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            stackViewLogin.heightAnchor.constraint(equalToConstant: 109),
            stackViewLogin.topAnchor.constraint(equalTo: textUp.bottomAnchor, constant: 30),
        ])
    }
    
    func setupStyle() {
        
    }
}



