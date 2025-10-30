import UIKit

class CreateListViewController: UIViewController {
    
    var createList = CreateList()
    weak var taskController: TasksViewController?
    let icons = [
        // 📦 Utilitários / Compras
        "cart", "bag.fill", "creditcard", "gift.fill", "tag.fill", "basket.fill",
        
        // 🏠 Casa / Rotina
        "house.fill", "hammer", "wrench.and.screwdriver.fill", "lightbulb.fill", "sofa.fill", "paintbrush.fill",
        
        // 🎯 Organização / Produtividade
        "checkmark.circle.fill", "list.bullet.rectangle", "calendar", "clock.fill", "alarm.fill", "bookmark.fill",
        
        // 🎉 Eventos / Festas
        "balloon.2.fill", "party.popper.fill", "sparkles", "camera.fill", "music.note", "gift.fill",
        
        // 🍔 Comida / Saúde
        "leaf.fill", "heart.fill", "fork.knife", "cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill",
        
        // 🧳 Viagem / Lazer
        "airplane", "map.fill", "tram.fill", "mappin.and.ellipse", "beach.umbrella.fill", "tent.fill",
        
        // 💼 Trabalho / Estudos
        "laptopcomputer", "doc.text.fill", "book.fill", "pencil", "folder.fill", "graduationcap.fill",
        
        // ⚽️ Esportes / Hobbies
        "figure.run", "figure.tennis", "soccerball", "bicycle", "dumbbell", "gamecontroller.fill",
        
        // 💬 Comunicação / Pessoal
        "message.fill", "phone.fill", "envelope.fill", "person.2.fill", "hands.sparkles.fill",
        
        // 💰 Finanças
        "dollarsign.circle.fill", "chart.line.uptrend.xyaxis", "wallet.pass.fill", "bag.circle.fill",
        
        // 🧘‍♂️ Bem-estar / Pessoal
        "moon.fill", "sun.max.fill", "sparkle.magnifyingglass", "cross.case.fill", "heart.text.square.fill"
    ]
    var selectedIcon: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = createList
                
        createList.iconsCollectionView.dataSource = self
        createList.iconsCollectionView.delegate = self
        createList.iconsCollectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.identifier)
        createList.delegate = self
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationSetup(title: "Criar Lista")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateListViewController: CreateListProtocol {
    func didTapChoiceIcon() {
        let isCollapsed = createList.collectionHeightConstraint.constant == 0
        createList.collectionHeightConstraint.constant = isCollapsed ? 370 : 0
        
        UIView.animate(withDuration: 0.3) {
            let rotationAngle: CGFloat = isCollapsed ? .pi : 0
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
        print("Ícone selecionado: \(selectedIcon!)")
    }
}
