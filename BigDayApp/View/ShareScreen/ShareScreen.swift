//
//  ShareScreen.swift
//  BigDayApp
//
//  Created by Davy Sousa on 08/07/25.
//
import UIKit

protocol TapButtonShareDelete: AnyObject {
    func didTapCopyPhotoBtn()
    func didTapWhiteColor()
    func didTapBlackColor()
    func didTapInfoButton()
    func didTapCopyShadowBtn()
}

class ShareScreen: UIView {
    
    weak var delegate: TapButtonShareDelete?
    
    public lazy var infoShareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapInfoShareButton), for: .touchUpInside)
        return button
    }()
    @objc private func didTapInfoShareButton() {
        delegate?.didTapInfoButton()
    }
    
    private lazy var textUp: UILabel = {
        let label = UILabel()
        label.text = "Copie sua lista e adicione sombra para destacar as tarefas!"
        label.font = UIFont(name: "Montserrat-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var copyPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tarefas", for: .normal)
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
        delegate?.didTapCopyPhotoBtn()
    }
    
    public lazy var copyShadowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sombra", for: .normal)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.backgroundColor = ColorSuport.greenApp
        button.clipsToBounds = true
        button.layer.cornerRadius = 45/2
        button.addTarget(self, action: #selector(didTapShadowButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapShadowButton() {
        delegate?.didTapCopyShadowBtn()
    }
    
    public lazy var colorWhiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorSuport.greenApp.cgColor
        button.layer.cornerRadius = 45/2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapColorWhiteBtn), for: .touchUpInside)
        return button
    }()
    @objc func didTapColorWhiteBtn() {
        delegate?.didTapWhiteColor()
    }
    
    public lazy var colorBlackButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorSuport.greenApp.cgColor
        button.layer.cornerRadius = 45/2
        button.addTarget(self, action: #selector(didTapColorBlackBtn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func didTapColorBlackBtn() {
        delegate?.didTapBlackColor()
    }
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [copyPhotoButton, copyShadowButton, colorWhiteButton, colorBlackButton])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackViewItems: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [containerView, textUp, buttonsStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    
    // Tela de compartilhar
    
    private lazy var labelUpUserName: UILabel = {
        let label = UILabel()
        label.text = "Big Day"
        label.textColor = ColorSuport.greenApp
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var nameUserLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var stackViewLogin: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelUpUserName, nameUserLabel])
        stack.spacing = 3
        stack.alignment = .leading
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public lazy var imageUser: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        image.tintColor = ColorSuport.greenApp
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        image.layer.cornerRadius = 50/2
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

    public lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
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
    func adjustTableViewHeight() {
        tasksTableView.layoutIfNeeded()
        let height = tasksTableView.contentSize.height
        tasksTableView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
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
        addSubview(buttonsStackView)
        addSubview(stackViewItems)
        containerView.addSubview(profileUserStackView)
        containerView.addSubview(dayLabel)
        containerView.addSubview(tasksTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            stackViewItems.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackViewItems.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 10),
            stackViewItems.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant: -10),
            stackViewItems.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackViewItems.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            copyPhotoButton.widthAnchor.constraint(equalToConstant: 130),
            copyPhotoButton.heightAnchor.constraint(equalToConstant: 45),
            copyShadowButton.widthAnchor.constraint(equalToConstant: 130),
            copyShadowButton.heightAnchor.constraint(equalToConstant: 45),
            
            colorWhiteButton.widthAnchor.constraint(equalToConstant: 45),
            colorWhiteButton.heightAnchor.constraint(equalToConstant: 45),
            colorBlackButton.widthAnchor.constraint(equalToConstant: 45),
            colorBlackButton.heightAnchor.constraint(equalToConstant: 45),
                    
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
        
    }
    
    
}
