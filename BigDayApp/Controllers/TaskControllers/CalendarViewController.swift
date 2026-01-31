import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    var calendarScreen = CalendarScreen()
    weak var taskController: TasksViewController?
    private var selectedDate: Date?
    
    private let cal = Calendar.current
    private func dayKey(_ d: Date) -> Int {
        let c = cal.dateComponents([.year,.month,.day], from: cal.startOfDay(for: d))
        return c.year! * 10_000 + c.month! * 100 + c.day!
    }
    
    var daysWithTasksKeys = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = calendarScreen
        view.backgroundColor = .clear
        navigationItem.backButtonTitle = ""
        calendarScreen.delegate = self
        calendarScreen.calendar.dataSource = self
        calendarScreen.calendar.delegate = self
        calendarScreen.styleCalendar()
        //calendarScreen.calendar.select()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let lastTimestamp = UserDefaults.standard.value(forKey: "ultimaDataSelecionada") {
            selectedDate = Date(timeIntervalSince1970: lastTimestamp as! TimeInterval)
        } else {
            selectedDate = Date()
        }
        
        calendarScreen.calendar.setCurrentPage(selectedDate!, animated: false)

        calendarScreen.calendar.select(selectedDate)
        
        // Descobre o mês visível (página atual do FSCalendar)
        let current = calendarScreen.calendar.currentPage
        let startOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: current))!
        var comps = DateComponents(); comps.month = 1; comps.day = -1
        let endOfMonth = cal.date(byAdding: comps, to: startOfMonth)!
        
        // Carrega tasks do mês visível
        taskController?.viewModel.loadTasksForMonth(startOfMonth, endOfMonth) { [weak self] in
            guard let self = self else { return }
            let todas = self.taskController?.viewModel.allTasks ?? []
            self.daysWithTasksKeys = Set(todas.map { self.dayKey($0.dueDate!) })
            self.calendarScreen.calendar.reloadData()
        }
    }
    
}

extension CalendarViewController: CalendarDelegate {
    func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func tapSelectButton() {
        guard let date = selectedDate else { return }
        UserDefaults.standard.set(date.timeIntervalSince1970, forKey: "ultimaDataSelecionada")

        taskController?.viewModel.updateSelectedDate(date)
        taskController?.taskScreen.dayLabel.text = DateHelper.dayTitle(from: date)
        SelectedDateStore.save(date)
        dismiss(animated: true)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let current = calendar.currentPage
        let startOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: current))!
        var comps = DateComponents(); comps.month = 1; comps.day = -1
        let endOfMonth = cal.date(byAdding: comps, to: startOfMonth)!

        taskController?.viewModel.loadTasksForMonth(startOfMonth, endOfMonth) { [weak self] in
            guard let self = self else { return }
            let todas = self.taskController?.viewModel.allTasks ?? []
            self.daysWithTasksKeys = Set(todas.map { self.dayKey($0.dueDate!) })
            self.calendarScreen.calendar.reloadData()
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarScreen.calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return daysWithTasksKeys.contains(dayKey(date)) ? 1 : 0
    }
}

