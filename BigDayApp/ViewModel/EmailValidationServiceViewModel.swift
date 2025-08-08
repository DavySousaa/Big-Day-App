import Foundation

enum EmailValidationResult {
    case success
    case failure(String)
}

class EmailValidationServiceViewModel {
    private let service = EmailValidationService()
    
    var onValidationResult: ((EmailValidationResult) -> Void)?
    
    func checkEmail(_ email: String) {
        service.validate(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if data.regexp && data.smtpCheck {
                        self?.onValidationResult?(.success)
                    } else {
                        self?.onValidationResult?(.failure("E-mail inválido ou não verificável."))
                    }
                case .failure(let error):
                    self?.onValidationResult?(.failure("Erro ao validar e-mail: \(error.localizedDescription)"))
                }
            }
        }
    }
}

