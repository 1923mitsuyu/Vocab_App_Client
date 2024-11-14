import Foundation

// TO DO LIST (11/15)
// 1. Create three http request handlings (add, edit, and delete)

struct FetchDeckResponse: Decodable {
    let message: String
    let decks: [Deck]
}

class DeckService {
    
    static let shared = DeckService()
    private init() {}
    
    func getDecks() async throws -> [Deck] {
        
        guard let url = URL(string: "http://localhost:3000/v1/fetch/deck") else {
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
            let fetchDeckResponse = try JSONDecoder().decode(FetchDeckResponse.self, from: data)
            
            return fetchDeckResponse.decks
            
        } catch {
            throw NetworkError.decodingError
        }
    }
    
//    func addDecks() async throws -> Deck {
//
//    }
//
//    func editDecks() async throws -> Deck {
//
//    }
//
//    func removeDecks() async throws -> Deck {
//
//    }
    
}
        

