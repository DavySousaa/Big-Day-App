import UIKit

protocol ListsViewDelegate: AnyObject {
    func didTapNewList()
}

class ListsView: UIView {
    
    weak var delegate: ListsViewDelegate?
    
    private lazy var textUp: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.textAlignment = .center
        
        let fullText = "Crie suas Big Listas\ne mantenha tudo\nsob controle."
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont(name: "Montserrat-ExtraBold", size: 27)!,
            .foregroundColor: UIColor.label
        ])
        
        let textColor = ColorSuport.greenApp
        let range = (fullText as NSString).range(of: "\nsob controle.")
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        
        text.attributedText = attributedString
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var newListButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Nova lista", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapButtonNewList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonNewList(){
        delegate?.didTapNewList()
    }
    
    public lazy var listsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 16
        table.clipsToBounds = true
        table.backgroundColor = UIColor(named: "PrimaryColor")
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListsView: SetupLayout {
    func addSubViews() {
        addSubview(textUp)
        addSubview(newListButton)
        addSubview(listsTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textUp.centerXAnchor.constraint(equalTo: centerXAnchor),
            textUp.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            
            newListButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            newListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            newListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            newListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            newListButton.heightAnchor.constraint(equalToConstant: 41),
            
            listsTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            listsTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            listsTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            listsTableView.topAnchor.constraint(equalTo: textUp.bottomAnchor, constant: 20),
            listsTableView.bottomAnchor.constraint(equalTo: newListButton.topAnchor, constant: -20)
        ])
    }
    
    func setupStyle() {
        
    }
    
}
