//
//  EmailValidationResponse.swift
//  BigDayApp
//
//  Created by Davy Sousa on 05/08/25.
//

import Foundation

struct EmailValidationResponse: Decodable {
    let email: String
    let formatValid: Bool
    let isMxFound: Bool
    let isSmtpValid: Bool
    let score: Double
    
    enum CodingKeys: String, CodingKey {
        case email
        case formatValid = "format_valid"
        case isMxFound = "mx_found"
        case isSmtpValid = "smtp_check"
        case score
    }
}

struct Format: Decodable {
    let value: Bool
}

class EmailValidationService {
    
    let apiKey = APIKey.emailValidation
    
    func validate(email: String, completion: @escaping(Result<EmailValidationResponse, Error>) -> Void) {
        
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.apilayer.com/email_verification/check?email=\(encodedEmail)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "Nada")
            
            if let errorResponse = try? JSONDecoder().decode(EmailValidationErrorResponse.self, from: data) {
                let errorDescription = "Erro \(errorResponse.error.code): \(errorResponse.error.type)"
                completion(.failure(NSError(domain: "", code: errorResponse.error.code, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(EmailValidationResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
