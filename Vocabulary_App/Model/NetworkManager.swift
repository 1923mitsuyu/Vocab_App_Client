import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case emptyData
    case decodingError
    case unexpectedData
    case other(Error)
}

// Manage a common process for any http requests
class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init () {}
    
    func request<T: Decodable>(endpoint: String, method: HTTPMethod, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))  
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        URLSession.shared.dataTask(with: request) { data, request, error in
            if let error {
                completion(.failure(NetworkError.other(error)))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.emptyData))
                return
            }
        
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
    
    func request(endpoint: String, method: HTTPMethod, parameters: [String: Any]? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = method.rawValue
        if let parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        URLSession.shared.dataTask(with: request) { data, request, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard data != nil else {
                completion(.success(()))
                return
            }
            
            completion(.failure(NetworkError.unexpectedData))
        }.resume()
    }
}
