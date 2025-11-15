import Foundation
import UIKit

class ListsViewController: UIViewController {
    
    var viewModel = ListsViewModel()
    var listsView = ListsView()
    var lists: [UserList] = []
    var currentList: UserList!
    var selectedListId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = listsView
        navigationController?.navigationBar.tintColor = .label
        listsView.delegate = self
        
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationSetupWithLogo(title: "Big Listas")
        navigationItem.backButtonTitle = "Voltar"
        
        
        setupTableView()
        bindViewModel()
        viewModel.listenToUserLists()
    }
    
    private func setupTableView() {
        listsView.listsTableView.delegate = self
        listsView.listsTableView.dataSource = self
        listsView.listsTableView.register(ListsCell.self, forCellReuseIdentifier: ListsCell.identifier)
        listsView.listsTableView.tintColor = .white
    }
    
    private func bindViewModel() {
        viewModel.onListsUpdate = { [weak self] lists in
            DispatchQueue.main.async {
                self?.lists = lists
                self?.listsView.listsTableView.reloadData()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            navigationSetupWithLogo(title: "Listas")
        }
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
            let selectedList = lists[indexPath.row]
            let detailsVC = ListViewController()
            detailsVC.currentList = selectedList
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            let listToDelete = self.lists[indexPath.row]
            self.viewModel.deleteList(listId: listToDelete.id ?? "")
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (_, _, completion) in
            let list = self.lists[indexPath.row]
            self.selectedListId = list.id
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        let editIcon = UIImage(systemName: "square.and.pencil")?.withTintColor(ColorSuport.blackApp, renderingMode: .alwaysOriginal)
        editAction.image = editIcon
        editAction.backgroundColor = ColorSuport.greenApp
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}

extension ListsViewController: ListsViewDelegate {
    func didTapNewList() {
        navigationController?.pushViewController(CreateListViewController(), animated: true)
    }
}

