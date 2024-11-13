import Foundation

class DeckService {
 
    // Deckの取得
    func fetchDeck(completion: @escaping (Result<[Deck], Error>) -> Void) {
        let endpoint = "https://api.example.com/deck"
        
        NetworkManager.shared.request(endpoint: endpoint, method: .get) { (result: Result<[Deck], Error>) in
            completion(result)
        }
    }
    
    // Deckの追加
    func createDeck(name: String, description: String?, completion: @escaping (Result<Deck, Error>) -> Void) {
        let endpoint = "https://api.example.com/deck"
        let parameters: [String: Any] = ["name": name, "description": description ?? ""]
        
        NetworkManager.shared.request(endpoint: endpoint, method: .post, parameters: parameters) { (result: Result<Deck, Error>) in
            completion(result)
        }
    }
    
    // Deckの編集
    func editDeck(deckId: Int, newName: String, completion: @escaping (Result<Deck, Error>) -> Void) {
        let endpoint = "https://api.example.com/deck/\(deckId)"
        let parameters: [String: Any] = ["name": newName]
        
        NetworkManager.shared.request(endpoint: endpoint, method: .put, parameters: parameters) { (result: Result<Deck, Error>) in
            completion(result)
        }
    }
    
    // Deckの削除
    func deleteDeck(deckId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "https://api.example.com/deck/\(deckId)"
        
        NetworkManager.shared.request(endpoint: endpoint, method: .delete) { (result: Result<Void, Error>) in
            completion(result)
        }
    }
}
