//
//  TaskCellShare.swift
//  BigDayApp
//
//  Created by Davy Sousa on 08/07/25.
//

import UIKit

class TaskCellShare: UITableViewCell {
    
    static let identifier = "TaskCellShare"
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let circleImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "circle"))
        image.tintColor = ColorSuport.greenApp
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.isOpaque = false
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byWordWrapping // ou .byWordWrapping se quiser quebrar linha
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        hourLabel.text = task.time ?? ""
        
        let imageName = task.isCompleted ? "checkmark.circle.fill" : "circle"
        circleImage.image = UIImage(systemName: imageName)
    }
    
    private func setup() {
        contentView.addSubview(circleImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(hourLabel)
        
        NSLayoutConstraint.activate([
            circleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            circleImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleImage.widthAnchor.constraint(equalToConstant: 22),
            circleImage.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleImage.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: hourLabel.leadingAnchor, constant: -10),
            hourLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            hourLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hourLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
