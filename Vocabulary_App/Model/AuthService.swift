import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

struct SignUpResponse: Decodable {
    let message: String
    let user: User
}

class AuthService {
    
    static let shared = AuthService()
    
    func login(username: String, password: String) async throws -> User {
        
        guard let url = URL(string: "http://localhost:3000/v1/login") else {
            throw NetworkError.invalidURL
        }
        
        // Create a URLRequest and configure it
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode parameters as JSON data
        let parameters = ["username": username, "password": password]
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
            let signUpResponse = try JSONDecoder().decode(SignUpResponse.self, from: data)
            print(signUpResponse.message)
            print(signUpResponse.user)
            
            let user = signUpResponse.user
            return user
            
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func signUp(username: String, password: String) async throws -> User {
        
        // Validate URL
        guard let url = URL(string: "http://localhost:3000/v1/signup") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["username": username, "password": password]
        
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
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let signUpResponse = try JSONDecoder().decode(SignUpResponse.self, from: data)
            
            print(signUpResponse.message)
            print(signUpResponse.user)
            
            let user = signUpResponse.user
            return user
            
        } catch {
            throw NetworkError.decodingError
        }
    }
}
