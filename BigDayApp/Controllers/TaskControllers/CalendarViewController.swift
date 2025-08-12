import UIKit
import FSCalendar


class CalendarViewController: UIViewController {
    
    var calendarScreen = CalendarScreen()
    var taskController: TasksViewController?
    private var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = calendarScreen
        view.backgroundColor = .clear
        navigationItem.backButtonTitle = ""
        calendarScreen.delegate = self
        calendarScreen.calendar.dataSource = self
        calendarScreen.calendar.delegate = self
        calendarScreen.styleCalendar()
    }
}

extension CalendarViewController: CalendarDelegate {
    func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func tapSelectButton() {
        guard let date = selectedDate else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_Br")
        formatter.dateFormat = "EEE',' 'dia' d 'de' MMMM"
        
        let formattedDate = formatter.string(from: date)
        
        taskController?.taskScreen.dayLabel.text = formattedDate
        dismiss(animated: true)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarScreen.calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    // Exemplo: permitir seleção
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        print("Selecionou:", date)
    }
    
    // Exemplo: número de eventos (pontinhos) num dia
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // Coloca sua lógica (ex.: se tem tarefa, retorna 1)
        return 0
    }
}
