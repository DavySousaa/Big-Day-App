//
//  ShareScreen.swift
//  BigDayApp
//
//  Created by Davy Sousa on 08/07/25.
//
import UIKit

protocol TapButtonShareDelete: AnyObject {
    func didTapStoryBtn()
    func didTapSaveBtn()
    func didTapCopyBtn()
}

class ShareScreen: UIView {
    
    weak var delegate: TapButtonShareDelete?
    
    private lazy var textUp: UILabel = {
        let label = UILabel()
        label.text = "Salve ou copie um screenshot da sua lista\nde tarefa e compartilhe em suas redes sociais."
        label.font = UIFont(name: "Montserrat-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var storyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Story", for: .normal)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.backgroundColor = ColorSuport.greenApp
        button.clipsToBounds = true
        button.layer.cornerRadius = 45/2
        button.addTarget(self, action: #selector(didTapStoryButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapStoryButton() {
        delegate?.didTapStoryBtn()
    }
    
    public lazy var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar", for: .normal)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.backgroundColor = ColorSuport.greenApp
        button.clipsToBounds = true
        button.layer.cornerRadius = 45/2
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapSaveButton() {
        delegate?.didTapSaveBtn()
    }
    
    public lazy var copyPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copiar", for: .normal)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.backgroundColor = ColorSuport.greenApp
        button.clipsToBounds = true
        button.layer.cornerRadius = 45/2
        button.addTarget(self, action: #selector(didTapCopyButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapCopyButton() {
        delegate?.didTapCopyBtn()
    }
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [storyButton,savePhotoButton,copyPhotoButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var backgroundContainerView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "ClearBackground"))
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    // Tela de compartilhar
    
    private lazy var labelUpUserName: UILabel = {
        let label = UILabel()
        label.text = "Big Day"
        label.textColor = ColorSuport.greenApp
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var nameUserLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var stackViewLogin: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelUpUserName, nameUserLabel])
        stack.spacing = 5
        stack.alignment = .leading
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public lazy var imageUser: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        image.tintColor = ColorSuport.greenApp
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image.layer.cornerRadius = 60/2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var profileUserStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageUser, stackViewLogin])
        stack.spacing = 6
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 14)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_Br")
        formatter.dateFormat = "EEEE',' 'dia' d 'de' MMMM"
        let formattedDate = formatter.string(from: date)
        label.text = formattedDate.capitalized
        
        return label
    }()
    
    public lazy var tasksTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.isScrollEnabled = false            
        table.isUserInteractionEnabled = false
        table.backgroundColor = .clear
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShareScreen: SetupLayout {
    func addSubViews() {
        addSubview(textUp)
        addSubview(buttonsStackView)
        addSubview(containerView)
        containerView.addSubview(backgroundContainerView)
        containerView.addSubview(profileUserStackView)
        containerView.addSubview(dayLabel)
        containerView.addSubview(tasksTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textUp.centerXAnchor.constraint(equalTo: centerXAnchor),
            textUp.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            backgroundContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            containerView.topAnchor.constraint(equalTo: textUp.bottomAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 500),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 45),
            
            profileUserStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            profileUserStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            dayLabel.topAnchor.constraint(equalTo: profileUserStackView.bottomAnchor, constant: 10),
            
            tasksTableView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 10),
            tasksTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    func setupStyle() {
        if let bgImage = UIImage(named: "ClearBackground")?.cgImage {
            containerView.layer.contentsGravity = .resizeAspectFill
        }
    }
    
    
}
