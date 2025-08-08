//
//  EmailValidationResponse.swift
//  BigDayApp
//
//  Created by Davy Sousa on 05/08/25.
//

import Foundation

struct EmailValidationResponse: Decodable {
    let data: EmailData
}

struct EmailData: Decodable {
    let email: String
    let result: String
    let score: Int
    let regexp: Bool
    let smtpCheck: Bool
    
    enum CodingKeys: String, CodingKey {
        case email
        case result
        case score
        case regexp
        case smtpCheck = "smtp_check"
    }
}

class EmailValidationService {
    
    let apiKey = APIKey.emailValidation // Chave do Hunter.io
    
    func validate(email: String, completion: @escaping (Result<EmailData, Error>) -> Void) {
        
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.hunter.io/v2/email-verifier?email=\(encodedEmail)&api_key=\(apiKey)") else {
            return
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
                
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Sem dados", code: -1)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(EmailValidationResponse.self, from: data)
                completion(.success(result.data))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
