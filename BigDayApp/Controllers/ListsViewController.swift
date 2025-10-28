import Foundation
import UIKit

class ListsViewController: UIViewController {
    
    var listsView = ListsView()
    var lists: [Lists] = [
        Lists(title: "Compras", iconName: "cart"),
        Lists(title: "Aniversário", iconName: "gift.fill"),
        Lists(title: "Reforma", iconName: "hammer"),
        Lists(title: "Compras para casa", iconName: "house.fill")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = listsView
        
        listsView.listsTableView.tintColor = .white
        
        listsView.listsTableView.register(ListsCell.self, forCellReuseIdentifier: ListsCell.identifier)
        listsView.listsTableView.delegate = self
        listsView.listsTableView.dataSource = self
        
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationSetupWithLogo(title: "Listas")
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
        cell.backgroundColor = .secondarySystemGroupedBackground
        
        return cell
    }
}

extension ListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ListsCell {
            
        }
    }
}

