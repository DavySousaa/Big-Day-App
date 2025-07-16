import UIKit

protocol FirstScreenDelegate: AnyObject {
    func didTapCreate()
    func didTapLogin()
}

class FirstScreen: UIView {
    
    weak var delegate: FirstScreenDelegate?
    
    public lazy var imageLogo: UIImageView = {
        let image = UIImageView()
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
            .foregroundColor: UIColor.label
        ])
        
        let bigDayColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "Big Day!")
        attributedString.addAttribute(.foregroundColor, value: bigDayColor, range: range)
        
        text.attributedText = attributedString
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    public lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Criar conta", for: .normal)
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.backgroundColor = ColorSuport.greenApp
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
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 41/2
        button.layer.borderColor = UIColor(hex: "#00C853").cgColor
        button.addTarget(self, action: #selector(didTapButtonLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonLogin(){
        delegate?.didTapLogin()
    }
    
    private lazy var stackViewButtons: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [createAccountButton, lognAccountButton])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 2 // ou quantas imagens você tiver
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = ColorSuport.greenApp
        pc.pageIndicatorTintColor = .systemGray4
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImages(_ images: [UIImage]) {
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = true
            
            stackView.addArrangedSubview(imageView)          // 1️⃣ entra na hierarquia
            imageView.widthAnchor
                .constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
                .isActive = true                             // 2️⃣ agora é seguro
        }
    }
}

extension FirstScreen : SetupLayout {
    func addSubViews() {
        addSubview(imageLogo)
        addSubview(textUp)
        addSubview(createAccountButton)
        addSubview(lognAccountButton)
        addSubview(stackViewButtons)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        addSubview(pageControl)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageLogo.heightAnchor.constraint(equalToConstant: 32),
            imageLogo.widthAnchor.constraint(equalToConstant: 83),
            imageLogo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            textUp.centerXAnchor.constraint(equalTo: centerXAnchor),
            textUp.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: 15),
            
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 384),
            scrollView.widthAnchor.constraint(equalToConstant: 326),
            scrollView.topAnchor.constraint(equalTo: textUp.bottomAnchor, constant: 20),
            
            // StackView presa ao CONTENT da ScrollView
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            // Altura igual pra não rolar verticalmente
            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            
            stackViewButtons.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackViewButtons.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 35),
            stackViewButtons.heightAnchor.constraint(equalToConstant: 87),
            stackViewButtons.widthAnchor.constraint(equalToConstant: 290),
            stackViewButtons.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createAccountButton.heightAnchor.constraint(equalToConstant: 41),
            lognAccountButton.heightAnchor.constraint(equalTo: createAccountButton.heightAnchor),
        ])
    }
    
    func setupStyle() {
    }
    
    
}
