struct EmailValidationErrorResponse: Decodable {
    let success: Bool
    let error: EmailValidationError
}

struct EmailValidationError: Decodable {
    let code: Int
    let type: String
}

