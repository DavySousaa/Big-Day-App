
import Foundation

class ListsSuportHelper {
    
    let keyList: String = "kList"
    
    public func addTask(lista:[UserList]) {
        do {
            let listAux = try JSONEncoder().encode(lista)
            UserDefaults.standard.setValue(listAux, forKey: self.keyList)
        } catch {
            print(error)
        }
    }
    
    public func getTask() -> [UserList] {
        do {
            guard let lists = UserDefaults.standard.object(forKey: self.keyList) else { return [] }
            let listAux = try JSONDecoder().decode([UserList].self, from: lists as! Data)
            
            return listAux
        } catch {
            print(error)
        }
        
        return []
    }
    
    func resetTasks() {
        UserDefaults.standard.removeObject(forKey: keyList)
    }
}
