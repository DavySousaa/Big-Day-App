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
}

class ConfigScreen: UIView {
    
    var delegate: tapButtonConfigDelete?
    var configViewController: ConfigViewController?
    
    public lazy var userPhoto: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        image.tintColor = ColorSuport.greenApp
        image.layer.cornerRadius = 60/2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    public lazy var editPhotoUser: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.label, for: .normal)
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
        textField.layer.cornerRadius = 45/2
        textField.textColor = .label
        textField.font = UIFont(name: "Montserrat-Regular", size: 15)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitleColor(.label, for: .normal)
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
    
    public lazy var configTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 16
        table.clipsToBounds = true
        table.backgroundColor = UIColor(named: "PrimaryColor")
        return table
    }()
    
    func updateTableHeight(rows: Int, rowHeight: CGFloat = 60) {
        let height = CGFloat(rows) * rowHeight
        configTableView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.frame.height / 2
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
        addSubview(editPhotoUser)
        addSubview(configTableView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            userPhoto.centerXAnchor.constraint(equalTo: centerXAnchor),
            userPhoto.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            userPhoto.widthAnchor.constraint(equalToConstant: 100),
            userPhoto.heightAnchor.constraint(equalToConstant: 100),
            
            editPhotoUser.centerXAnchor.constraint(equalTo: centerXAnchor),
            editPhotoUser.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 5),
            
            configTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            configTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            configTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
            configTableView.topAnchor.constraint(equalTo: editPhotoUser.bottomAnchor, constant: 20),
        ])
    }
    
    func setupStyle() {
        
    }
}
