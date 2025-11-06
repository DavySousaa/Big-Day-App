import UIKit

class ListView: UIView {
    
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
    
    public lazy var listsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 16
        table.clipsToBounds = true
        table.backgroundColor = .lightGray
        table.backgroundColor = .clear
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

extension ListView: SetupLayout {
    func addSubViews() {
        addSubview(titleList)
        addSubview(listsTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleList.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleList.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleList.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            titleList.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            listsTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            listsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            listsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            listsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            listsTableView.topAnchor.constraint(equalTo: titleList.bottomAnchor, constant: 10),
        ])
    }
    
    func setupStyle() {
        
    }
}
