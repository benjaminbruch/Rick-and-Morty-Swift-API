//
//  NetworkHandler.swift
//  Created by BBruch on 08.04.20.
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
    let next: String
    let prev: String
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
    case invalidResponse
    case apiError
    case decodingError
}

/**
 Struct for handling network requests and decoding JSON data
 ### Functions
 - **performAPIRequestByMethod**
 - **performAPIRequestByURL**
 - **decodeJSONData**
 */
public struct NetworkHandler {
    let baseURL: String = "https://rickandmortyapi.com/api/"
    
    /**
     Perform API request with given method.
     - Parameters:
        - method: URL for API request.
     - Returns: HTTP data response.
     */
    func performAPIRequestByMethod(method: String, completion: @escaping (Result<Data, NetworkHandlerError>) -> Void) {
        if let url = URL(string: baseURL+method) {
            print("HTTP-Request: "+baseURL+method)
            let urlSession = URLSession.shared
            urlSession.dataTask(with: url) { result in switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
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
     Perform API request with given URL.
     - Parameters:
        - url: URL for API request.
     - Returns: HTTP data response.
     */
    func performAPIRequestByURL(url: String, completion: @escaping (Result<Data, NetworkHandlerError>) -> Void) {
        if let url = URL(string: url) {
            print(url)
            let urlSession = URLSession.shared
            urlSession.dataTask(with: url) { result in switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
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
            print(error)
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
