import UIKit

protocol FirstScreenDelegate: AnyObject {
    func didTapCreate()
    func didTapLogin()
}

class FirstScreen: UIView {
    
    weak var delegate: FirstScreenDelegate?
    
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
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.9
        text.baselineAdjustment = .alignCenters
        
        let fullText = "Transformando\ndias comuns em\nBig Day!"
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 26)!,
            .foregroundColor: UIColor.black
        ])
        
        let bigDayColor = UIColor(hex: "#77D36A")
        let range = (fullText as NSString).range(of: "Big Day!")
        attributedString.addAttribute(.foregroundColor, value: bigDayColor, range: range)
        
        text.attributedText = attributedString
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var ImageCell: UIImageView = {
        let image = UIImageView(image: UIImage(named: "IphoneImage"))
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Criar conta", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#222222")
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapButtonCreate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonCreate(){
        delegate?.didTapCreate()
    }
    
    private lazy var lognAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Já tem conta? Acesse aqui", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 41/2
        button.layer.borderColor = UIColor(hex: "#00C853").cgColor
        button.addTarget(self, action: #selector(didTapButtonLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonLogin(){
        delegate?.didTapLogin()
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [createAccountButton, lognAccountButton])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.distribution = .fill
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

extension FirstScreen : SetupLayout {
    func addSubViews() {
        addSubview(imageLogo)
        addSubview(textUp)
        addSubview(ImageCell)
        addSubview(createAccountButton)
        addSubview(lognAccountButton)
        addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageLogo.heightAnchor.constraint(equalToConstant: 44),
            imageLogo.widthAnchor.constraint(equalToConstant: 114),
            imageLogo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            
            textUp.centerXAnchor.constraint(equalTo: centerXAnchor),
            textUp.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: 15),
            
            
            ImageCell.centerXAnchor.constraint(equalTo: centerXAnchor),
            ImageCell.heightAnchor.constraint(equalToConstant: 384),
            ImageCell.widthAnchor.constraint(equalToConstant: 326),
            ImageCell.topAnchor.constraint(equalTo: textUp.bottomAnchor, constant: 20),
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: ImageCell.bottomAnchor, constant: 35),
            stackView.heightAnchor.constraint(equalToConstant: 87),
            stackView.widthAnchor.constraint(equalToConstant: 290),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createAccountButton.heightAnchor.constraint(equalToConstant: 41),
            lognAccountButton.heightAnchor.constraint(equalTo: createAccountButton.heightAnchor),
        ])
    }
    
    func setupStyle() {
    }
    
    
}
