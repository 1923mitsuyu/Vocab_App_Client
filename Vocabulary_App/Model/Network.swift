
import Foundation

class Network: ObservableObject {
    
    @Published var users: [User] = []
        
    func getUsers() async throws -> [User] {
        print("Making a request to get user info")
        guard let url = URL(string: "http://localhost:3000/login") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        do {
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            return decodedUsers
        } catch {
            throw error
        }
    }
    
    func createUsers(user: User) async throws -> [User] {
        print("Creaing a new user in db")
        guard let url = URL(string: "http://localhost:3000/signUp") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
       
        // Encode the user data into JSON
        do {
            let jsonData = try JSONEncoder().encode(user)
            urlRequest.httpBody = jsonData
        } catch {
            throw NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error encoding user data"])
        }
        
        // Set the content-type to JSON
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response or failed to create user"])
        }
        
        do {
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            return decodedUsers
        } catch {
            throw error
        }
    }
}

