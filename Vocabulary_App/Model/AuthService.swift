import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

class AuthService {
    
    static let shared = AuthService()
    
    func login(email: String, password: String) async throws -> User {
        guard let url = URL(string: "http://localhost:3000/login") else {
            throw NetworkError.invalidURL
        }
        
        // Create a URLRequest and configure it
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode parameters as JSON data
        let parameters = ["email": email, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw NetworkError.invalidResponse
        }
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into a User object
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func signUp(email: String, password: String) async throws -> User {
        // Validate URL
        guard let url = URL(string: "http://localhost:3000/signup") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["email": email, "password": password]
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encoding parameters as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw NetworkError.invalidResponse
        }
        
        // Perform network request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into User object
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            throw NetworkError.decodingError
        }
    }
}
