import UIKit

class CreateListViewController: UIViewController, UITextFieldDelegate {
    
    var viewModel = CreateListViewModel()
    var createList = CreateList()
    weak var taskController: TasksViewController?
    var selectedIcon: String = ""
    var icons = IconList.icons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = createList
        
        createList.iconsCollectionView.dataSource = self
        createList.iconsCollectionView.delegate = self
        createList.iconsCollectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.identifier)
        createList.delegate = self
        createList.titleTextField.delegate = self
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationSetup(title: "Criar Lista")
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func bindViewModel() {
        viewModel.onSucess = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension CreateListViewController: CreateListProtocol {
    func didTapCreateList() {
        let title = createList.titleTextField.text ?? ""
        let iconName = selectedIcon
        
        viewModel.createList(title: title, iconName: iconName)
        
    }
    
    func didTapChoiceIcon() {
        let isCollapsed = createList.collectionHeightConstraint.constant == 0
        createList.collectionHeightConstraint.constant = isCollapsed ? 400 : 0
        
        UIView.animate(withDuration: 0.3) {
            let rotationAngle: CGFloat = .pi
            self.createList.iconSectionButton.imageView?.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.view.layoutIfNeeded()
        }
    }
}

extension CreateListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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


