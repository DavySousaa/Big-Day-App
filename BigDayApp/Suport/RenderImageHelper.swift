import UIKit
import Foundation

class RenderImageHelper {
    
    var shareScreen = ShareScreen()
    
    func renderViewAsImage(view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
    func createShareImage(from containerView: UIView, tableView: UITableView) -> UIImage? {
        tableView.layoutIfNeeded()
        containerView.backgroundColor = .clear
        containerView.layoutIfNeeded()
        let image = renderViewAsImage(view: containerView)
        containerView.backgroundColor = .secondarySystemBackground
        return image
    }
}
