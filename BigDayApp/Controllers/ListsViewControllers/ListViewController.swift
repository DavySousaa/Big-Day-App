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
        listView.delegate = self
        
        navigationSetupItems(iconName: currentList.iconName)
        navigationItem.backButtonTitle = "Voltar"
        
        setupTableView()
        bindViewModel()
        viewModel.listenItems(listId: currentList.id!)
        fillTitleList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeight()
    }
    
    func navigationSetupItems(iconName: String) {
        navigationController?.navigationBar.tintColor = ColorSuport.greenApp
        
        let image = UIImage(systemName: iconName)
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorSuport.greenApp
                
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        navigationItem.titleView = imageView
    }
    
    private func setupTableView() {
        listView.listsTableView.delegate = self
        listView.listsTableView.dataSource = self
        listView.listsTableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        listView.listsTableView.tintColor = .white
        
        listView.listsTableView.rowHeight = UITableView.automaticDimension
        listView.listsTableView.estimatedRowHeight = 60
    }
    
    private func bindViewModel() {
        viewModel.onItemsUpdate = { [weak self] items in
            DispatchQueue.main.async {
                self?.items = items
                self?.listView.listsTableView.reloadData()
                self?.updateTableHeight()
            }
        }
    }
    
    private func updateTableHeight() {
        view.layoutIfNeeded()
        
        let tableView = listView.listsTableView
        tableView.layoutIfNeeded()
        
        let contentHeight = tableView.contentSize.height
        
        let buttonTop = listView.newItemListButton.frame.minY
        let containerTop = listView.tableContainerView.frame.minY
        
        let spacingToButton: CGFloat = 10
        
        let availableHeight = buttonTop - spacingToButton - containerTop
        let maxHeight = max(0, availableHeight) // evita valor negativo
        
        let targetHeight = min(contentHeight, maxHeight)
        listView.tableHeightConstraint.constant = targetHeight
        
        tableView.isScrollEnabled = contentHeight > maxHeight
        
        view.layoutIfNeeded()
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
            self.viewModel.addItem(listId: currentList.id!, title: text)
        })
        present(alert, animated: true)
    }
    
    func toggleCompletion(at indexPath: IndexPath) {
        var item = items[indexPath.row]
        item.isCompleted.toggle()
        viewModel.updateCompletion(listId: currentList.id!, itemId: item.id, isCompleted: item.isCompleted)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let list = items[indexPath.row]
        cell.configure(with: list)
        cell.backgroundColor = .systemGray6
        
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
        toggleCompletion(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            var item = self.items[indexPath.row]
            self.viewModel.deleteItem(listId: self.currentList.id!, itemId: item.id)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension ListViewController: ItemListViewDelegate {
    func didTapNewItem() {
        showAddItemField()
    }
}
