import Foundation
import FirebaseFirestore

final class DetailViewModel {
    
    var task: Task?
    
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    
}
