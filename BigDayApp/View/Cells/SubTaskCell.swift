import UIKit

class SubTaskCell: UITableViewCell {
    
    static let identifier = "SubTaskCell"
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Regular", size: 16)
        label.textColor = ColorSuport.blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let circleImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "circle"))
        image.tintColor = .label
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
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
    
    func configure(with task: SubTask) {
        titleLabel.text = task.title
        
        let imageName = task.isCompleted ? "checkmark.circle.fill" : "circle"
        circleImage.image = UIImage(systemName: imageName)
    }
    
    private func setup() {
        contentView.addSubview(circleImage)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            circleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            circleImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleImage.widthAnchor.constraint(equalToConstant: 24),
            circleImage.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleImage.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),

        ])
    }
}
