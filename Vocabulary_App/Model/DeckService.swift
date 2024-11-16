import Foundation

// TO DO LIST (11/16)
// 1. Create three http request handlings (add, edit, and delete)

struct FetchDecksResponse: Decodable {
    let message: String
    let decks: [Deck]
}

struct DeckResponse: Decodable {
    let message: String
    let deck: Deck
}

class DeckService {
    
    static let shared = DeckService()
    private init() {}
    
    func getDecks() async throws -> [Deck] {
        
        guard let url = URL(string: "http://localhost:3000/v1/fetch/decks") else {
            throw NetworkError.invalidURL
        }
        
        // Create a URLRequest and configure it
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let fetchDeckResponse = try JSONDecoder().decode(FetchDecksResponse.self, from: data)
            
            return fetchDeckResponse.decks
            
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func addDeck(name: String, words: [String], listOrder: Int, userId: Int) async throws -> Deck {

        guard let url = URL(string: "http://localhost:3000/v1/add") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["name": name, "words": words, "listOrder": listOrder, "userId": userId]
        
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
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let deckResponse = try JSONDecoder().decode(DeckResponse.self, from: data)
            
            print(deckResponse.message)
            print(deckResponse.deck)
            
            let deck = deckResponse.deck
            return deck
            
        } catch {
            throw NetworkError.decodingError
        }
    
    }
    
//    func editDeck(name: String, words: [String], listOrder: Int, userId: Int) async throws -> Deck {
//
//    }
//
//    func deleteDeck(name: String, words: [String], listOrder: Int, userId: Int) async throws -> Deck {
//
//    }
    
}
        

