import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    var calendarScreen = CalendarScreen()
    weak var taskController: TasksViewController?
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
        guard let date = selectedDate else { return }
        taskController?.viewModel.updateSelectedDate(date)
        taskController?.taskScreen.dayLabel.text = DateHelper.dayTitle(from: date)
        SelectedDateStore.save(date) // <- salva
        dismiss(animated: true)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarScreen.calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        print("Selecionou:", date)
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // (Opcional) se quiser mostrar o pontinho quando houver tarefas:
        // return taskController?.viewModel.hasTasks(on: date) == true ? 1 : 0
        return 0
    }
}

