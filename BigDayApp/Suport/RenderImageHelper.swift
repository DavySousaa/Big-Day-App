import UIKit

final class RenderImageHelper {

    func renderViewAsImage(view: UIView) -> UIImage? {
        // drawHierarchy é ótimo pra capturar visual “real”
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }

    func createShareImageFullTable(from containerView: UIView, tableView: UITableView) -> UIImage? {
        // Garante que a table calculou alturas
        tableView.layoutIfNeeded()
        containerView.layoutIfNeeded()

        // Salva estado original
        let originalContainerFrame = containerView.frame
        let originalTableFrame = tableView.frame
        let originalOffset = tableView.contentOffset
        let originalBG = containerView.backgroundColor

        // Altura total do conteúdo
        let fullHeight = tableView.contentSize.height

        // Sobe pro topo (pra evitar capturar “meio do scroll”)
        tableView.setContentOffset(.zero, animated: false)
        tableView.layoutIfNeeded()

        // Expande frames temporariamente
        containerView.backgroundColor = .clear
        tableView.frame.size.height = fullHeight
        containerView.frame.size.height = max(originalContainerFrame.height, fullHeight)

        // Recalcula layout com os novos tamanhos
        tableView.layoutIfNeeded()
        containerView.layoutIfNeeded()

        // Renderiza a imagem
        let image = renderViewAsImage(view: containerView)

        // Restaura tudo
        containerView.frame = originalContainerFrame
        tableView.frame = originalTableFrame
        tableView.setContentOffset(originalOffset, animated: false)
        containerView.backgroundColor = originalBG

        return image
    }
    
    func copyImageFromAssets(named imageName: String) {
        if let image = UIImage(named: imageName) {
            UIPasteboard.general.image = image
            print("Imagem '\(imageName)' copiada com sucesso!")
        } else {
            print("❌ Não foi possível encontrar a imagem '\(imageName)' nos Assets.")
        }
    }
}
