import Foundation

struct FetchDecksResponse: Decodable {
    let message: String
    let decks: [Deck]?
}

struct DeckResponse: Decodable {
    let message: String
}

class DeckService {
    
    static let shared = DeckService()
    private init() {}
    
    func getDecks(userId: Int) async throws -> [Deck] {
        
        guard let url = URL(string: "http://localhost:3000/v1/fetchDecks/\(userId)") else {
            throw NetworkError.invalidURL
        }
        
        // Create a URLRequest and configure it
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
   
        let (data, response) = try await URLSession.shared.data(for: request)
    
        // Log raw server response for debugging
        if let rawResponse = String(data: data, encoding: .utf8) {
             print("Raw server response for fetching decks:", rawResponse)
         }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let fetchDeckResponse = try JSONDecoder().decode(FetchDecksResponse.self, from: data)
          
            if fetchDeckResponse.decks?.isEmpty ?? true {
                print("No decks found for user \(userId).")
                return []
            } else {
                return fetchDeckResponse.decks!
            }
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func addDeck(name: String, deckOrder: Int, userId: Int) async throws {
        
        guard let url = URL(string: "http://localhost:3000/v1/saveDeck") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["name": name, "deckOrder": deckOrder, "userId": userId]
        print("Parameters being sent:", parameters)
        
        // Create a URL request
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
        
        // Log raw server response for debugging
         if let rawResponse = String(data: data, encoding: .utf8) {
             print("Raw server response for adding a new deck:", rawResponse)
         }
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into DeckResponse object to get the message
        do {
            print("Trying to decode the response")
            let deckResponse = try JSONDecoder().decode(DeckResponse.self, from: data)
            
            print(deckResponse.message)
                        
        } catch {
            throw NetworkError.decodingError
        }
        
    }
    
    func editDeck(deckId: Int, name: String) async throws {
        guard let url = URL(string: "http://localhost:3000/v1/modifyDeck") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["deckId": deckId, "name": name]
        print("Parameters being sent:", parameters)
        
        // Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encoding parameters as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw NetworkError.invalidResponse
        }
        
        // Perform network request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Log raw server response for debugging
         if let rawResponse = String(data: data, encoding: .utf8) {
             print("Raw server response for editing:", rawResponse)
         }
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let deckResponse = try JSONDecoder().decode(DeckResponse.self, from: data)
            
            print(deckResponse.message)
            
        } catch {
            throw NetworkError.decodingError
        }
    }

    func deleteDeck(deckId: Int, userId: Int) async throws {
       
        guard let url = URL(string: "http://localhost:3000/v1/removeDeck") else {
            throw URLError(.badURL)
        }
        
        // Set parameters
        let parameters: [String: Any] = ["deckId": deckId, "userId": userId]
        print("Parameters being sent:", parameters)
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Include the userId in the body or headers if required for authorization
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        // Execute the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let rawResponse = String(data: data, encoding: .utf8) {
            print("Raw server response:", rawResponse)
        }
        
        // Check the response status
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let deckResponse = try JSONDecoder().decode(DeckResponse.self, from: data)
            
            print(deckResponse.message)
            
        } catch {
            throw NetworkError.decodingError
        }
    }
}
        

