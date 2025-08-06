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
                case .success(let response):
                    if response.formatValid && response.isSmtpValid {
                        self?.onValidationResult?(.success)
                    } else {
                        self?.onValidationResult?(.failure("E-mail inválido. Verifique se ele está digitado corretamente."))
                    }
                case .failure(let error):
                    self?.onValidationResult?(.failure("Erro ao validar: \(error.localizedDescription)"))
                }
            }
        }
    }
}

