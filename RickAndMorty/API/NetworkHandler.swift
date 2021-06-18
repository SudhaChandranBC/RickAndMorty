//
//  NetworkHandler.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import Foundation

/**
 ResponseInfo struct for decoding api response info.
 ### Properties
 - **count**: The length of the response.
 - **pages**: The amount of pages.
 - **next**: Link to the next page (if it exists)
 - **prev**: Link to the previous page (if it exists).
 */
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

/**
 Types of network errors
 ### Properties
 - **invalidURL**: URL request error.
 - **invalidResponse**: HTTP request error.
 - **apiError**: API request error.
 - **decodingError**: Decoding request error.
 */
enum NetworkHandlerError: Error {
    case invalidURL
    case invalidResponse(error: ErrorMessage)
    case apiError
    case decodingError
}

/**
 Error Message
 ### Properties
 - **error**: The error string.
 */
struct ErrorMessage: Codable {
    let error: String
}

/**
 Struct for handling network requests and decoding JSON data
 ### Functions
 - **performAPIRequestByMethod**
 - **performAPIRequestByURL**
 - **decodeJSONData**
 */
public struct NetworkHandler {
    var baseURL: String = "https://rickandmortyapi.com/api/"
    
    /**
     Perform API request with given method.
     - Parameters:
     - method: URL for API request.
     - completion: Completion block.
     - Returns: HTTP data response.
     */
    func performAPIRequestByMethod(method: String, completion: @escaping (Result<Data, NetworkHandlerError>) -> Void) {
        if let url = URL(string: baseURL+method) {
            let urlSession = URLSession.shared
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            
            if let cacheResponse = urlSession.configuration.urlCache?.cachedResponse(for: request) {
                do {
                    return completion(.success(cacheResponse.data))
                }
            }
            urlSession.dataTask(with: url) {
                switch $0 {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse(error: decodeError(data: data) ?? ErrorMessage(error: "invalidResponse"))))
                        return
                    }
                    completion(.success(data))
                case .failure( _):
                    completion(.failure(.apiError))
                }
            }.resume()
        } else {
            completion(.failure(.invalidURL))
        }
    }
    
    /**
     Decode JSON response for codable struct model.
     - Parameters:
     - data: HTTP data response.
     - Returns: Model struct of associated variable type.
     */
    func decodeJSONData<T: Codable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
    
    /**
     Decode JSON error response.
     - Parameters:
     - data: HTTP data response.
     - Returns: Error message struct.
     */
    func decodeError(data: Data) -> ErrorMessage? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ErrorMessage.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}

/**
 Extension to implement <Result> type in URLSession.
 */
extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
