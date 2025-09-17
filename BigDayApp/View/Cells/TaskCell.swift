import UIKit
import Foundation

protocol CircleButtonProtocool: AnyObject {
    func tapCircleButton(_ cell: TaskCell)
}

class TaskCell: UITableViewCell {
    
    static let identifier = "TaskCell"
    var delegate: CircleButtonProtocool?
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 16)
        label.textColor = ColorSuport.blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let circleBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "circle"), for: .normal)
        btn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        btn.tintColor = .label
        btn.backgroundColor = .clear
        btn.adjustsImageWhenHighlighted = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(tapCircleBtn), for: .touchUpInside)
        return btn
    }()
    @objc func tapCircleBtn() {
        delegate?.tapCircleButton(self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        selectionStyle = .none
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
        circleBtn.isSelected = task.isCompleted
        
        if task.isCompleted {
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                             .foregroundColor: UIColor.label]
            )
        } else {
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: 0,
                             .foregroundColor: UIColor.label]
            )
        }
    }
    
    private func setup() {
        contentView.addSubview(circleBtn)
        contentView.addSubview(titleLabel)
        contentView.addSubview(hourLabel)
        
        NSLayoutConstraint.activate([
            circleBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            circleBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleBtn.widthAnchor.constraint(equalToConstant: 24),
            circleBtn.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleBtn.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: hourLabel.leadingAnchor, constant: -10),
            
            hourLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hourLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
