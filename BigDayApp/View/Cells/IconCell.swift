import UIKit

class IconCell: UICollectionViewCell {
    static let identifier = "IconCell"
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                backgroundColor = ColorSuport.greenApp
                iconView.tintColor = .white
            } else {
                backgroundColor = .clear
                iconView.tintColor = .label
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconView)
        iconView.frame = contentView.bounds
        layer.cornerRadius = 40/2
        clipsToBounds = true
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(iconName: String) {
        iconView.image = UIImage(systemName: iconName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
