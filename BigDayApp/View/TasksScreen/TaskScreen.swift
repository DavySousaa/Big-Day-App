//
//  TaskScreen.swift
//  BigDayApp
//
//  Created by Davy Sousa on 26/06/25.
//

import UIKit
import Foundation
import FirebaseAuth

protocol TapButtonDelete: AnyObject {
    func didTapCreate()
    func didTapDelete()
    func didTapCalendar()
}

class TaskScreen: UIView {
    
    weak var delegate: TapButtonDelete?
    
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
    
    private lazy var viewDayLabel: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSuport.greenApp
        view.clipsToBounds = true
        view.layer.cornerRadius = 30/2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 14)
        label.textColor = ColorSuport.blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_Br")
        formatter.dateFormat = "EEE',' 'dia' d 'de' MMMM"
        let formattedDate = formatter.string(from: date)
        label.text = formattedDate.capitalized
        
        return label
    }()
    
    private lazy var buttonCalendar: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = .label
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.addTarget(self, action: #selector(didTapButtonCalendar), for: .touchUpInside)
        return button
    }()
    @objc private func didTapButtonCalendar(){
        delegate?.didTapCalendar()
    }
    
    private lazy var newTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.layer.cornerRadius = 30/2
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        button.addTarget(self, action: #selector(didTapButtonCreate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonCreate(){
        delegate?.didTapCreate()
    }
    
    private lazy var deleteAllTasks: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapButtonDelete), for: .touchUpInside)
        return button
    }()
    @objc private func didTapButtonDelete(){
        delegate?.didTapDelete()
    }

    public lazy var tasksTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor(named: "PrimaryColor")
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
        addSubview(viewDayLabel)
        addSubview(dayLabel)
        addSubview(newTaskButton)
        addSubview(deleteAllTasks)
        addSubview(buttonCalendar)
        addSubview(tasksTableView)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileUserStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            profileUserStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            dayLabel.topAnchor.constraint(equalTo: profileUserStackView.bottomAnchor, constant: 18),
            viewDayLabel.leadingAnchor.constraint(equalTo: dayLabel.leadingAnchor, constant: -20),
            viewDayLabel.trailingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 20),
            viewDayLabel.heightAnchor.constraint(equalToConstant: 30),
            viewDayLabel.topAnchor.constraint(equalTo: dayLabel.topAnchor, constant: -5),

            newTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            newTaskButton.topAnchor.constraint(equalTo: profileUserStackView.bottomAnchor, constant: 14),
            newTaskButton.centerYAnchor.constraint(equalTo: viewDayLabel.centerYAnchor),
            newTaskButton.heightAnchor.constraint(equalToConstant: 30),
            
            deleteAllTasks.trailingAnchor.constraint(equalTo: newTaskButton.leadingAnchor, constant: -5),
            deleteAllTasks.centerYAnchor.constraint(equalTo: viewDayLabel.centerYAnchor),
            deleteAllTasks.topAnchor.constraint(equalTo: profileUserStackView.bottomAnchor, constant: 14),
            
            buttonCalendar.topAnchor.constraint(equalTo: profileUserStackView.bottomAnchor, constant: 15),
            buttonCalendar.centerYAnchor.constraint(equalTo: viewDayLabel.centerYAnchor),
            buttonCalendar.leadingAnchor.constraint(equalTo: viewDayLabel.trailingAnchor, constant: 5),
            
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

