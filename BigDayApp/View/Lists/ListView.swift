import UIKit

protocol ItemListViewDelegate: AnyObject {
    func didTapNewItem()
}

class ListView: UIView {
    
    var delegate: ItemListViewDelegate?
    
    public var titleList: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let tableContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = .systemGray6
        return view
    }()
    
    public lazy var listsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.separatorStyle = .none
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 16
        table.clipsToBounds = true
        table.backgroundColor = .lightGray
        table.backgroundColor = .clear
        return table
    }()
    
    public var newItemListButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.setTitleColor(ColorSuport.blackApp, for: .normal)
        button.setTitle("Adicionar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-ExtraBold", size: 16)
        button.layer.cornerRadius = 41/2
        button.addTarget(self, action: #selector(didTapButtonNewItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc private func didTapButtonNewItem(){
        delegate?.didTapNewItem()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var tableHeightConstraint: NSLayoutConstraint!
    
}

extension ListView: SetupLayout {
    func addSubViews() {
        addSubview(titleList)
        addSubview(tableContainerView)
        tableContainerView.addSubview(listsTableView)
        addSubview(newItemListButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleList.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleList.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleList.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            titleList.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            tableContainerView.topAnchor.constraint(equalTo: titleList.bottomAnchor, constant: 10),
            tableContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            newItemListButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            newItemListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            newItemListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            newItemListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            newItemListButton.heightAnchor.constraint(equalToConstant: 41),
            
            listsTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            listsTableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            listsTableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            listsTableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            listsTableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
        ])
        tableHeightConstraint = tableContainerView.heightAnchor.constraint(equalToConstant: 100)
        tableHeightConstraint.isActive = true
    }
    
    func setupStyle() {
        
    }
}
