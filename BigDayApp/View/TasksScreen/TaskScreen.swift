//
//  TaskScreen.swift
//  BigDayApp
//
//  Created by Davy Sousa on 26/06/25.
//

import UIKit
import Foundation
import FirebaseAuth

protocol CreateTaskDelete: AnyObject {
    func didTapCreate()
}

class TaskScreen: UIView {
    
    weak var delegate: CreateTaskDelete?
    
    private lazy var labelUpUserName: UILabel = {
        let label = UILabel()
        label.text = "Big Day"
        label.textColor = ColorSuport.greenApp
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameUserLabel: UILabel = {
        let label = UILabel()
        label.text = "Davy Sousa"
        label.textColor = ColorSuport.blackApp
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
    
    private lazy var imageUser: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        image.tintColor = ColorSuport.blackApp
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
        stack.spacing = 3
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public lazy var configButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 14)
        label.textColor = ColorSuport.blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_Br")
        formatter.dateFormat = "EEEE',' 'dia' d 'de' MMMM"
        let formattedDate = formatter.string(from: date)
        label.text = formattedDate.capitalized
        
        label.backgroundColor = ColorSuport.greenApp
        label.widthAnchor.constraint(equalToConstant: 220).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.layer.cornerRadius = 30/2
        label.clipsToBounds = true
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var newTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        button.addTarget(self, action: #selector(didTapButtonCreate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonCreate(){
        delegate?.didTapCreate()
    }
    
    public lazy var tasksTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
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

extension TaskScreen: SetupLayout {
    func addSubViews() {
        addSubview(profileUserStackView)
        addSubview(dayLabel)
        addSubview(newTaskButton)
        addSubview(tasksTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileUserStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            profileUserStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dayLabel.topAnchor.constraint(equalTo: profileUserStackView.bottomAnchor, constant: 15),
            
            newTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            newTaskButton.topAnchor.constraint(equalTo: profileUserStackView.bottomAnchor, constant: 15),
            
            tasksTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tasksTableView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 15),
        ])
    }
    
    func setupStyle() {
        
    }
}

