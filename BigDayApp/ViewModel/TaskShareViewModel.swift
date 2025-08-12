//
//  TaskShareViewModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 26/07/25.
//

import Foundation
import FirebaseFirestore

final class TaskShareViewModel {
    
    // Saídas para a VC
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    var tasksChanged: (() -> Void)?

    // Dependências
    private let repo = TaskRepository.shared

    // Estado
    private(set) var tasks: [Task] = [] {
        didSet { tasksChanged?() }
    }
    private(set) var selectedDate: Date = Date()

    // MARK: - Ciclo de vida de bindings
    /// Começa a observar o dia atual
    func bind() {
        observeDay()
    }

    /// Troca o dia observado (chame ao sair do calendário)
    func updateSelectedDate(_ date: Date) {
        selectedDate = date
        observeDay()
    }

    private func observeDay() {
        repo.observeDay(selectedDate) { [weak self] result in
            switch result {
            case .success(let items):
                // Ordena por 'order' (se existir), senão por createdAt lá no query
                self?.tasks = items.sorted { (a, b) in
                    (a.order ?? Int.max) < (b.order ?? Int.max)
                }
                self?.onSucess?()
            case .failure(let error):
                self?.onError?("Erro ao carregar tarefas: \(error.localizedDescription)")
            }
        }
    }

    deinit {
        repo.stopObserveDay()
    }

    // MARK: - CRUD
    /// Cria uma task para o dia selecionado (timeString: ex. "14:30" ou nil)
    func addTask(title: String, timeString: String?) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onError?("Dê um nome para sua tarefa.")
            return
        }

        let due = DateHelper.combine(day: selectedDate, timeHM: timeString)
        let hasTime = (timeString?.isEmpty == false)

        repo.createTask(title: title,
                        timeString: timeString,
                        dueDate: due,
                        hasTime: hasTime) { [weak self] result in
            switch result {
            case .success:
                self?.onSucess?()
            case .failure(let err):
                self?.onError?("Erro ao criar: \(err.localizedDescription)")
            }
        }
    }

    func updateTask(id: String, title: String, timeString: String?) {
        var payload: [String: Any] = ["title": title]
        if let timeString, !timeString.isEmpty {
            payload["time"] = timeString
            payload["hasTime"] = true
            // Atualiza dueDate combinando com o dia da própria task
            let due = DateHelper.combine(day: selectedDate, timeHM: timeString)
            payload["dueDate"] = Timestamp(date: due)
        } else {
            payload["time"] = NSNull()
            payload["hasTime"] = false
            let due = DateHelper.combine(day: selectedDate, timeHM: nil)
            payload["dueDate"] = Timestamp(date: due)
        }

        repo.update(id: id, fields: payload) { [weak self] err in
            if let err = err {
                self?.onError?("Erro ao atualizar: \(err.localizedDescription)")
            } else {
                self?.onSucess?()
            }
        }
    }

    func toggleTask(at index: Int) {
        guard tasks.indices.contains(index),
              let id = tasks[index].firebaseId else { return }
        let newValue = !(tasks[index].isCompleted)
        repo.toggleDone(id: id, isDone: newValue)
    }

    func deleteTask(at index: Int) {
        guard tasks.indices.contains(index),
              let id = tasks[index].firebaseId else { return }
        repo.delete(id: id) { [weak self] err in
            if let err = err {
                self?.onError?("Erro ao excluir: \(err.localizedDescription)")
            } else {
                self?.onSucess?()
            }
        }
    }

    /// Exclui todas as tasks do dia atualmente carregado
    func deleteAllForSelectedDay() {
        let group = DispatchGroup()
        var firstError: Error?

        tasks.forEach { t in
            guard let id = t.firebaseId else { return }
            group.enter()
            repo.delete(id: id) { err in
                if firstError == nil { firstError = err }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            if let err = firstError {
                self?.onError?("Erro ao excluir todas: \(err.localizedDescription)")
            } else {
                self?.onSucess?()
            }
        }
    }

    // MARK: - Reordenação (persistindo campo `order`)
    func moveTask(from sourceIndex: Int, to destinationIndex: Int) {
        guard tasks.indices.contains(sourceIndex),
              tasks.indices.contains(destinationIndex) else { return }

        let movedTask = tasks.remove(at: sourceIndex)
        tasks.insert(movedTask, at: destinationIndex)

        persistOrder()
    }

    /// Persiste a ordem atual do array no Firestore (order = índice)
    private func persistOrder() {
        // batch simples: atualiza `order` de todo mundo conforme posição
        let updates: [(id: String, order: Int)] = tasks.enumerated().compactMap { idx, t in
            guard let id = t.firebaseId else { return nil }
            return (id, idx)
        }

        let group = DispatchGroup()
        var firstError: Error?

        updates.forEach { pair in
            group.enter()
            repo.update(id: pair.id, fields: ["order": pair.order]) { err in
                if firstError == nil { firstError = err }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            if let err = firstError {
                self?.onError?("Erro ao salvar ordenação: \(err.localizedDescription)")
            } else {
                self?.onSucess?()
            }
        }
    }
}
