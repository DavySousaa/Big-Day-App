import UIKit

class AboutAppView: UIView {

    // MARK: - Views

    private lazy var textUp: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.textAlignment = .center
        
        let fullText = "Somos o\nBigDay App"
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 27)!,
            .foregroundColor: UIColor.label
        ])
        
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "BigDay App")
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        
        text.attributedText = attributedString
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    public lazy var versionLabel: UILabel = {
        let label = UILabel()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        label.text = "Versão \(version) (\(build))"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    public lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = """
        O Big Day nasceu com o objetivo de transformar dias comuns em dias incríveis.

        Criamos esse app pra te ajudar a manter o foco, planejar sua rotina com propósito e celebrar cada conquista do seu dia.

        Acreditamos que todo dia pode ser um grande dia. 💪🚀
        """
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var developerLabel: UILabel = {
        let label = UILabel()
        label.text = "Desenvolvido por Davy Sousa\nApaixonado por criar experiências Apple 🍎"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var instagramLabel: UILabel = {
        let label = UILabel()
        label.text = "Instagram: @davy.developer"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(textUp)
        addSubview(bodyLabel)
        addSubview(versionLabel)
        addSubview(developerLabel)
        addSubview(instagramLabel)

        NSLayoutConstraint.activate([
            textUp.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            textUp.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textUp.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            bodyLabel.topAnchor.constraint(equalTo: textUp.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            instagramLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            instagramLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            developerLabel.bottomAnchor.constraint(equalTo: instagramLabel.topAnchor, constant: -4),
            developerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            developerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            versionLabel.bottomAnchor.constraint(equalTo: developerLabel.topAnchor, constant: -4),
            versionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
