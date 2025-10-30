import Foundation
import UIKit

class ListsViewController: UIViewController {
    
    var listsView = ListsView()
    var lists: [Lists] = [
        Lists(title: "Compras", iconName: "cart"),
        Lists(title: "Aniversário", iconName: "gift.fill"),
        Lists(title: "Reforma", iconName: "hammer"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = listsView
        navigationController?.navigationBar.tintColor = .label
        listsView.listsTableView.tintColor = .white
        
        listsView.listsTableView.register(ListsCell.self, forCellReuseIdentifier: ListsCell.identifier)
        listsView.listsTableView.delegate = self
        listsView.listsTableView.dataSource = self
        listsView.delegate = self
        
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationSetupWithLogo(title: "Listas")
        navigationItem.backButtonTitle = "Voltar"
    }
}

extension ListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListsCell.identifier, for: indexPath) as? ListsCell else {
            return UITableViewCell()
        }
        let list = lists[indexPath.row]
        cell.configure(with: list)
        cell.backgroundColor = .clear
        
        return cell
    }
}

extension ListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ListsCell {
            
        }
    }
}

extension ListsViewController: ListsViewDelegate {
    func didTapNewList() {
        print("clicou no botão")
        navigationController?.pushViewController(CreateListViewController(), animated: true)
    }
}
