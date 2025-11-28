import UIKit
import Foundation

final class RepeatDayCell: UICollectionViewCell {
    
    static let identifier = "RepeatDayCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with option: RepeatOption) {
        titleLabel.text = option.title.uppercased()
        isSelected = option.isSelected
    }
    
    private func updateAppearance() {
        if isSelected {
            contentView.backgroundColor = ColorSuport.greenApp
            titleLabel.textColor = .white
        } else {
            contentView.backgroundColor = UIColor.systemGray6
            titleLabel.textColor = .label
        }
    }
}
