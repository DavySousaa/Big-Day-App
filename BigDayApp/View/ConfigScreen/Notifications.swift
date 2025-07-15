//
//  changeNickName.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//
import UIKit

protocol NotificationDelete {
    func switchOff(_ sender: UISwitch)
}

class Notifications: UIView {
    
    var delegate: NotificationDelete?
    
    private lazy var textNotification: UILabel = {
        let label = UILabel()
        label.text = "Vamos te lembrar das suas tarefas e também\nte motivar ao longo do dia. Tudo pra te ajudar\na viver um verdadeiro Big Day."
        label.numberOfLines = 3
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 11)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var switchPicker: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = ColorSuport.greenApp
        toggle.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    @objc private func switchToggled(_ sender: UISwitch) {
        delegate?.switchOff(sender)
    }
    
    private lazy var itemsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textNotification, switchPicker])
        stack.axis = .horizontal
        stack.spacing  = 8
        stack.alignment = .center
        stack.layer.cornerRadius = 12
        stack.layer.borderWidth = 1
        stack.layer.borderColor = UIColor.systemGray.cgColor
        stack.backgroundColor = .clear
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
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

extension Notifications: SetupLayout {
    func addSubViews() {
        addSubview(itemsStackView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            itemsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            itemsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            itemsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            itemsStackView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    func setupStyle() {
        
    }
}
