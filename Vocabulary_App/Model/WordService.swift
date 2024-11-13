import Foundation

class WordService {
    
    // Deckの単語を取得
    func fetchWordsForDeck(deckId: Int, completion: @escaping (Result<[Deck], Error>) -> Void) {
        let endpoint = "https://api.example.com/deck/\(deckId)/words"
        
        NetworkManager.shared.request(endpoint: endpoint, method: .get) { (result: Result<[Deck], Error>) in
            completion(result)
        }
    }
    
    // Deckに単語を追加
    func addWord(deckId: Int, word: String, meaning: String, completion: @escaping (Result<Deck, Error>) -> Void) {
        let endpoint = "https://api.example.com/deck/\(deckId)/word"
        let parameters: [String: Any] = ["word": word, "meaning": meaning]
        
        NetworkManager.shared.request(endpoint: endpoint, method: .post, parameters: parameters) { (result: Result<Deck, Error>) in
            completion(result)
        }
    }

    // Deckの単語を編集
    func updateWord(deckId: Int, wordId: Int, newWord: String, newMeaning: String, completion: @escaping (Result<Deck, Error>) -> Void) {
        let endpoint = "https://api.example.com/deck/\(deckId)/word/\(wordId)"
        let parameters: [String: Any] = ["word": newWord, "meaning": newMeaning]
        
        NetworkManager.shared.request(endpoint: endpoint, method: .put, parameters: parameters) { (result: Result<Deck, Error>) in
            completion(result)
        }
    }

    // Deckの単語を削除
    func deleteWord(deckId: Int, wordId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "https://api.example.com/deck/\(deckId)/word/\(wordId)"
        
        NetworkManager.shared.request(endpoint: endpoint, method: .delete) { (result: Result<Void, Error>) in
                completion(result)
            }
    }
}
