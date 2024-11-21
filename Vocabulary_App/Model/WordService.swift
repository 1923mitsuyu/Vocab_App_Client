import Foundation

struct FetchWordsResponse: Decodable {
    let message: String
    let words: [Word]
}

struct WordResponse: Decodable {
    let message: String
    let word: Word
}

class WordService {
    
    static let shared = WordService()
    private init() {}
    
    func getWords(deckId: Int) async throws -> [Word] {
        
        guard let url = URL(string: "http://localhost:3000/v1/fetchWords/\(deckId)") else {
            throw NetworkError.invalidURL
        }
        
        // Create a URLRequest and configure it
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Log raw server response for debugging
        //if let rawResponse = String(data: data, encoding: .utf8) {
            // print("Raw server response:", rawResponse)
         //}
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let fetchWordsResponse = try JSONDecoder().decode(FetchWordsResponse.self, from: data)
            
            return fetchWordsResponse.words
            
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func addWords(word:String, definition: String, example: String, translation: String, correctTimes: Int, word_order: Int, deckId: Int) async throws -> Word {
        
        guard let url = URL(string: "http://localhost:3000/v1/saveWord") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["word": word, "definition": definition, "example": example, "translation": translation, "correctTimes": correctTimes, "word_order": word_order, "deckId": deckId]
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
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let wordResponse = try JSONDecoder().decode(WordResponse.self, from: data)
            
            print(wordResponse.message)
            print(wordResponse.word)
            
            let word = wordResponse.word
            return word
            
        } catch {
            throw NetworkError.decodingError
        }
    
    }
    
//    func editWord(word:String, definition: String, example: String, translation: String, wordOrder: Int, deckId: Int) async throws -> Word {
//        return
//    }
//    
//    func deleteWord(word:String, definition: String, example: String, translation: String, wordOrder: Int, deckId: Int) async throws -> Word {
//        return
//    }
    
}

