//
//  taskSuportHelper.swift
//  Big Day App
//
//  Created by Davy Sousa on 15/03/25.
//
import Foundation

class TaskSuportHelper {
    
    let keyTask: String = "kTask"
    
    public func addTask(lista:[Task]) {
        do {
            let listAux = try JSONEncoder().encode(lista)
            UserDefaults.standard.setValue(listAux, forKey: self.keyTask)
        } catch {
            print(error)
        }
    }

    public func getTask() -> [Task] {
        do {
            guard let lista = UserDefaults.standard.object(forKey: self.keyTask) else { return [] }
            let listAux = try JSONDecoder().decode([Task].self, from: lista as! Data)
            
            return listAux
        } catch {
            print(error)
        }
        
        return []
    }

    public func updateTask() {
        
    }
}
