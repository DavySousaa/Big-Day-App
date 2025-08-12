import Foundation
import UIKit

final class FloatingTabBar: UITabBar {
    private let horizontalInset: CGFloat = 16
    private let bottomOffset: CGFloat = 25
    private let barHeight: CGFloat = 50

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var s = super.sizeThatFits(size)
        s.height = barHeight + safeAreaInsets.bottom
        return s
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        
        let newFrame = CGRect(
            x: horizontalInset,
            y: superview!.bounds.height - (barHeight + safeAreaInsets.bottom) - bottomOffset,
            width: superview!.bounds.width - (horizontalInset * 2),
            height: barHeight + safeAreaInsets.bottom
        )
        frame = newFrame

        
        layer.cornerRadius = 50
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)

        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            appearance.backgroundColor = UIColor(named: "PrimaryColor") ?? .secondarySystemBackground
            standardAppearance = appearance
            scrollEdgeAppearance = appearance
        } else {
            shadowImage = UIImage()
            backgroundImage = UIImage()
            barTintColor = UIColor(named: "PrimaryColor")
        }
    }
}
