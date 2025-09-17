import UIKit

final class DetailsTask: UIView {
    
    public lazy var titleTask: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = ColorSuport.greenApp
        label.font = UIFont(name: "Montserrat-ExtraBold", size: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textViewDescription: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Descrição..."
        tv.textColor = .label
        tv.backgroundColor = UIColor(named: "PrimaryColor")
        tv.layer.cornerRadius = 20
        tv.layer.borderWidth = 1
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        tv.layer.borderColor = UIColor.lightGray.cgColor
        return tv
    }()
    
    private lazy var subTasksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sub-Tarefas"
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.textColor = .label
        return label
    }()
    
    private lazy var newSubTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ColorSuport.greenApp
        button.layer.cornerRadius = 30/2
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = ColorSuport.blackApp
        //button.addTarget(self, action: #selector(didTapButtonCreate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var subTasksTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.showsVerticalScrollIndicator = false
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

extension DetailsTask: SetupLayout {
    func addSubViews() {
        addSubview(titleTask)
        addSubview(textViewDescription)
        addSubview(subTasksLabel)
        addSubview(newSubTaskButton)
        addSubview(subTasksTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTask.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTask.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleTask.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleTask.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            textViewDescription.centerXAnchor.constraint(equalTo: centerXAnchor),
            textViewDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textViewDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textViewDescription.topAnchor.constraint(equalTo: titleTask.bottomAnchor, constant: 20),
            textViewDescription.heightAnchor.constraint(equalToConstant: 150),
            
            subTasksLabel.topAnchor.constraint(equalTo: textViewDescription.bottomAnchor, constant: 25),
            subTasksLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            newSubTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            newSubTaskButton.topAnchor.constraint(equalTo: textViewDescription.bottomAnchor, constant: 20),
            newSubTaskButton.heightAnchor.constraint(equalToConstant: 30),
            newSubTaskButton.widthAnchor.constraint(equalToConstant: 30),
            
            subTasksTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTasksTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTasksTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTasksTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            subTasksTableView.topAnchor.constraint(equalTo: newSubTaskButton.bottomAnchor, constant: 15),
        ])
    }
    
    func setupStyle() {
        
    }
    
    
}
