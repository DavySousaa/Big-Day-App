import UIKit

protocol SaveEditListProcol: AnyObject {
    func saveEditList(titleEdit: String, iconNameEdit: String)
}

class EditListsViewController: UIViewController {
    
    var viewModel = EditListViewModel()
    var editLists = EditLists()
    var delegate: SaveEditListProcol?
    weak var listsController: ListsViewController?
    var selectedIcon: String = ""
    var icons = IconList.icons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editLists
        
        editLists.iconsCollectionView.dataSource = self
        editLists.iconsCollectionView.delegate = self
        editLists.iconsCollectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.identifier)
        editLists.delegate = self
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationSetup(title: "Editar Lista")
        bindViewModel()
        fillEditItens()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func fillEditItens() {
        if let list = viewModel.listToEdit {
            selectedIcon = list.iconName
            editLists.iconLabel.text = list.iconName
            
            if let index = icons.firstIndex(of: list.iconName) {
                let indexPath = IndexPath(item: index, section: 0)
                editLists.iconsCollectionView.layoutIfNeeded()
                editLists.iconsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            }
            editLists.collectionHeightConstraint.constant = 400
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func bindViewModel() {
        viewModel.onSucess = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        viewModel.onErorr = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension EditListsViewController: EditListProtocol {
    func didTapSaveList() {
        let newTitle = editLists.titleTextField.text ?? ""
        let newIconName = selectedIcon
        
        viewModel.saveEditList(title: newTitle, iconName: newIconName)
    }
    
    func didTapChoiceIcon() {
        let isCollapsed = editLists.collectionHeightConstraint.constant == 0
        editLists.collectionHeightConstraint.constant = isCollapsed ? 400 : 0
        
        UIView.animate(withDuration: 0.3) {
            let rotationAngle: CGFloat = isCollapsed ? .pi : 0
            self.editLists.iconSectionButton.imageView?.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.view.layoutIfNeeded()
        }
    }
}

extension EditListsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath) as! IconCell
        cell.configure(iconName: icons[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIcon = icons[indexPath.item]
        print("Ícone selecionado: \(selectedIcon)")
    }
}


