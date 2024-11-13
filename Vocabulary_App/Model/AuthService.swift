import Foundation // OK

class AuthService {
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let url = URL(string: "http://localhost:3000/login") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let parameters: [String: Any] = ["email": email, "password": password]
        
        NetworkManager.shared.request(endpoint: url.absoluteString, method: .post, parameters: parameters) { (result: Result<User, Error>) in
            completion(result)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let url = URL(string: "http://localhost:3000/signup") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let parameters: [String: Any] = ["email": email, "password": password]
        NetworkManager.shared.request(endpoint: url.absoluteString, method: .post, parameters: parameters) { (result: Result<User, Error>) in
            completion(result)
        }
    }
}
