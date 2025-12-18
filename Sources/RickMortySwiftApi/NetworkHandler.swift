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
    let next: String?
    let prev: String?
}

/**
 Types of network errors
 ### Properties
 - **InvalidURL**.
 - **JSONDecodingError**
 - **RequestError**
 - **UnknownError**
 */
public enum NetworkHandlerError: Error, Sendable {
    case InvalidURL
    case JSONDecodingError
    case RequestError(String)
    case UnknownError
}

struct ResponseErrorMessage: Codable {
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
     - Returns: HTTP data response.
     */
    func performAPIRequestByMethod(method: String) async throws -> Data {
        if let url = URL(string: baseURL+method) {
            print("📮 RequestURL: \(baseURL)\(method)")
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
               let error: ResponseErrorMessage = try decodeJSONData(data: data)
               throw NetworkHandlerError.RequestError(error.error)
            }
            return data
        } else {
            throw(NetworkHandlerError.InvalidURL)
        }
    }
    
    /**
     Perform API request with given URL.
     - Parameters:
        - url: URL for API request.
     - Returns: HTTP data response.
     */
    func performAPIRequestByURL(url: String) async throws -> Data {
        if let url = URL(string: url) {
            print("📮 RequestURL: \(url)")
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
               let error: ResponseErrorMessage = try decodeJSONData(data: data)
               throw NetworkHandlerError.RequestError(error.error)
            }
            return data
        } else {
            throw(NetworkHandlerError.InvalidURL)
        }
    }
    
    /**
     Decode JSON response for codable struct model.
     - Parameters:
        - data: HTTP data response.
     - Returns: Model struct of associated variable type.
     */
    func decodeJSONData<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkHandlerError.JSONDecodingError
        }
    }
}

