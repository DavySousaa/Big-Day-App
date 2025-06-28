
import UIKit

class NewTasksViewController: UIViewController {
    
    var newTask = NewTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = newTask
        view.backgroundColor = .clear
        navigationItem.backButtonTitle = ""
    }
    
    
}
