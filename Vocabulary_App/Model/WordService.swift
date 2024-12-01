import Foundation

struct FetchWordsResponse: Decodable {
    let message: String
    var words: [Word]?
}

struct WordResponse: Decodable {
    let message: String
    let word: Word
}

struct EditWordResponse: Decodable {
    let message: String
}

struct DeleteWordResponse: Decodable {
    let message: String
}

struct ExampleGeneratedResponse: Decodable {
    let message: String
    let content: [String]
}

class WordService {
    
    static let shared = WordService()
    private init() {}
    
    func generateSentence(word: String, definition: String) async throws -> String {
        
        guard let url = URL(string: "http://localhost:3000/v1/generateContent") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["word": word, "definition": definition]
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let wordResponse = try JSONDecoder().decode(ExampleGeneratedResponse.self, from: data)
            let sentence = wordResponse.content[0]
            return sentence
            
        } catch {
            throw NetworkError.decodingError
        }
        
    }
    
    func generateTranslation(example: String) async throws -> String {
        
        guard let url = URL(string: "http://localhost:3000/v1/generateTranslation") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["example": example]
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let wordResponse = try JSONDecoder().decode(ExampleGeneratedResponse.self, from: data)
            let translation = wordResponse.content[0]
            return translation
            
        } catch {
            throw NetworkError.decodingError
        }
        
    }
        
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
        if let rawResponse = String(data: data, encoding: .utf8) {
            print("Raw server response:", rawResponse)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let fetchWordsResponse = try JSONDecoder().decode(FetchWordsResponse.self, from: data)
            
            // Check if words is nil or empty
            if fetchWordsResponse.words?.isEmpty ?? true {
                print("No words found for deck \(deckId).")
                return []
            } else {
                return fetchWordsResponse.words!
            }
            
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
    
    func editWord(wordId: Int, word: String, definition: String, example: String, translation: String) async throws {
        
        guard let url = URL(string: "http://localhost:3000/v1/modifyWord") else {
            throw NetworkError.invalidURL
        }
        
        // Set parameters
        let parameters: [String: Any] = ["wordId": wordId, "word": word, "definition": definition, "example": example, "translation": translation]
        print("Parameters being sent:", parameters)
        
        // Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encoding parameters as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("JSON Encoding Error: \(error)")
            throw NetworkError.invalidResponse
        }
        
        // Perform network request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Log raw server response for debugging
        if let rawResponse = String(data: data, encoding: .utf8) {
            print("Raw server response:", rawResponse)
        }
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let editWordResponse = try JSONDecoder().decode(EditWordResponse.self, from: data)
            
            print(editWordResponse.message)
            
        } catch {
            throw NetworkError.decodingError
        }
        
    }
    
    func updateCorrectCount(_ words: [[String: Any]]) async throws {
        
        guard let url = URL(string: "http://localhost:3000/v1/modifyCorrectCount") else {
            throw NetworkError.invalidURL
        }
        
        // Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encoding parameters as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: words)
        } catch {
            print("JSON Encoding Error: \(error)")
            throw NetworkError.invalidResponse
        }
        
        // Perform network request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Log raw server response for debugging
        if let rawResponse = String(data: data, encoding: .utf8) {
            print("Raw server response:", rawResponse)
        }
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response data into SignUpResponse object to get the message
        do {
            let editWordResponse = try JSONDecoder().decode(EditWordResponse.self, from: data)
            
            print(editWordResponse.message)
            
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func updateWordOrder(_ words: [[String: Any]]) async throws {
        
        guard let url = URL(string: "http://localhost:3000/v1/modifyWordOrders") else {
            throw NetworkError.invalidURL
        }
        
        // Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encoding parameters as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: words)
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
            let wordResponse = try JSONDecoder().decode(EditWordResponse.self, from: data)
            
            print(wordResponse.message)
            
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func deleteWord(wordId: Int, deckId: Int) async throws {
        // Correct URL to use wordId for deletion
        guard let url = URL(string: "http://localhost:3000/v1/removeWord") else {
            throw URLError(.badURL)
        }
        
        // Set parameters
        let parameters: [String: Any] = ["wordId": wordId, "deckId": deckId]
        print("Parameters being sent:", parameters)
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Include the userId in the body or headers if required for authorization
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        // Execute the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the response status
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let deleteWordResponse = try JSONDecoder().decode(DeleteWordResponse.self, from: data)
            
            print(deleteWordResponse.message)
            
        } catch {
            throw NetworkError.decodingError
        }
    }
}

