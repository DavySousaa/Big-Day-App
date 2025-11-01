import UIKit

protocol CreateListProtocol {
    func didTapChoiceIcon()
    func didTapCreateList()
}

class CreateList: UIView {
    
    var delegate: CreateListProtocol?
    
    private lazy var tittleList: UILabel = {
        let label = UILabel()
        label.text = "Qual o título da lista?"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 47/2
        textField.attributedPlaceholder = NSAttributedString(
            string: "Digite...",
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
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.text = "Escolha um ícone."
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconSectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Escolha um ícone", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.addTarget(self, action: #selector(toggleIconsSection), for: .touchUpInside)
        button.tintColor = .label
        return button
    }()
    @objc func toggleIconsSection() {
        delegate?.didTapChoiceIcon()
    }
    
    let iconsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var creatButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Criar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapCreateListButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func didTapCreateListButton() {
        delegate?.didTapCreateList()
    }
    
    var collectionHeightConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero)
        setup()
        iconsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        iconsCollectionView.backgroundColor = UIColor(named: "PrimaryColor")
        iconSectionButton.translatesAutoresizingMaskIntoConstraints = false
        
        collectionHeightConstraint = iconsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionHeightConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateList: SetupLayout {
    func addSubViews() {
        addSubview(tittleList)
        addSubview(titleTextField)
        addSubview(creatButton)
        addSubview(iconSectionButton)
        addSubview(iconsCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tittleList.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            tittleList.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            
            titleTextField.topAnchor.constraint(equalTo: tittleList.bottomAnchor, constant: 10),
            titleTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 47),
            
            iconSectionButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            iconSectionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            
            iconsCollectionView.topAnchor.constraint(equalTo: iconSectionButton.bottomAnchor, constant: 10),
            iconsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            iconsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            creatButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            creatButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            creatButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            creatButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            creatButton.heightAnchor.constraint(equalToConstant: 41),
        ])
    }
    
    func setupStyle() {
        
    }
    
    
}
