import UIKit

class ListViewController: UIViewController {
    
    var currentList: UserList!
    var listView = ListView()
    var viewModel = ListItemsViewModel()
    var items: [ListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = listView
        navigationController?.navigationBar.tintColor = .label
    
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationSetup(title: "Lista")
        navigationItem.backButtonTitle = "Voltar"
        
        setupTableView()
        bindViewModel()
        viewModel.listenItems(listId: currentList.id)
        fillTitleList()
    }
    
    private func setupTableView() {
        listView.listsTableView.delegate = self
        listView.listsTableView.dataSource = self
        listView.listsTableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        listView.listsTableView.tintColor = .white
    }
    
    private func bindViewModel() {
        viewModel.onItemsUpdate = { [weak self] items in
            DispatchQueue.main.async {
                self?.items = items
                self?.listView.listsTableView.reloadData()
            }
        }
    }
    
    func fillTitleList() {
        listView.titleList.text = currentList.title
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showAddItemField() {
        let alert = UIAlertController(title: "Novo item", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Digite o nome do item"
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default) { [weak self] _ in
            guard let self,
                  let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            self.viewModel.addItem(listId: currentList.id, title: text)
        })
        present(alert, animated: true)
    }
    
    func toggleCompletion(at indexPath: IndexPath) {
        var item = items[indexPath.row]
        item.isCompleted.toggle()
        viewModel.updateCompletion(listId: currentList.id, itemId: item.id, isCompleted: item.isCompleted)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == items.count {
            let addCell = UITableViewCell(style: .default, reuseIdentifier: "addCell")
            addCell.textLabel?.text = "Adicionar novo item"
            addCell.textLabel?.textColor = .lightGray
            addCell.selectionStyle = .none
            addCell.textLabel?.textAlignment = .center
            addCell.backgroundColor = UIColor(named: "PrimaryColor")
            return addCell
        }
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let list = items[indexPath.row]
        cell.configure(with: list)
        cell.backgroundColor = UIColor(named: "PrimaryColor")
        
        if list.isCompleted {
            cell.circleImage.image = UIImage(systemName: "checkmark.circle.fill")
            let attributedText = NSAttributedString(
                string: list.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.label
                ]
            )
            cell.titleLabel.attributedText = attributedText
        } else {
            cell.circleImage.image = UIImage(systemName: "circle")
            
            let attributedText = NSAttributedString(
                string: list.title,
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: UIColor.label
                ]
            )
            cell.titleLabel.attributedText = attributedText
        }
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selecionou a célula \(indexPath.row)")
        
        if indexPath.row == items.count {
            print("Clicou no botão de adicionar")
            showAddItemField()
        } else {
            toggleCompletion(at: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            var item = self.items[indexPath.row]
            self.viewModel.deleteItem(listId: self.currentList.id, itemId: item.id)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
