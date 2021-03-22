//
//  Character.swift
//  Created by BBruch on 08.04.20.
//

import Foundation

/**
Character struct contains all functions to request character(s) information(s).
*/
public struct RMCharacter {
    
    public init(client: RMClient) {self.client = client}
    
    let client: RMClient
    let networkHandler: NetworkHandler = NetworkHandler()
    
    /**
     Request character by id.
     - Parameters:
        - id: ID of the character.
     - Returns: Character model struct.
     */
    public func getCharacterByID(id: Int, completion: @escaping (Result<CharacterModel, Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "character/"+String(id)) {
            switch $0 {
            case .success(let data):
            if let character: CharacterModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(character))
            }
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }
    
    /**
     Request character by URL.
     - Parameters:
        - url: URL of the character.
     - Returns: Character model struct.
     */
    public func getCharacterByURL(url: String, completion: @escaping (Result<CharacterModel, Error>) -> Void) {
        networkHandler.performAPIRequestByURL(url: url) {
            switch $0 {
            case .success(let data):
            if let character: CharacterModel = self.networkHandler.decodeJSONData(data: data) {
            completion(.success(character))
            }
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }
    
    /**
     Request multiple characters by IDs.
    - Parameters:
        - ids: Character ids.
     - Returns: Array of Character model struct.
     */
    public func getCharactersByID(ids: [Int], completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        let stringIDs = ids.map { String($0) }
        networkHandler.performAPIRequestByMethod(method: "character/"+stringIDs.joined(separator: ",")) {
            switch $0 {
            case .success(let data):
            if let characters: [CharacterModel] = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(characters))
            }
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }
    
    /**
     Request characters by page number.
     - Parameters:
        - page: Number of result page.
     - Returns: Array of Character model struct.
     */
    public func getCharactersByPageNumber(pageNumber: Int, completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "character/"+"?page="+String(pageNumber)) {
            switch $0 {
            case .success(let data):
            if let infoModel: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
            completion(.success(infoModel.results))
            }
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }
    
    /**
     Request all characters.
     - Returns: Array of Character model struct.
     */
    public func getAllCharacters(completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        var allCharacters = [CharacterModel]()
        networkHandler.performAPIRequestByMethod(method: "character") {
            switch $0 {
            case .success(let data):
            if let infoModel: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                allCharacters = infoModel.results
                let charactersDispatchGroup = DispatchGroup()
                
                for index in 2...infoModel.info.pages {
                    charactersDispatchGroup.enter()
                    self.getCharactersByPageNumber(pageNumber: index) {
                        switch $0 {
                        case .success(let characters):
                        allCharacters.append(contentsOf:characters)
                        charactersDispatchGroup.leave()
                        case .failure(let error):
                        completion(.failure(error))
                        }
                    }
                }
                charactersDispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(.success(allCharacters.sorted { $0.id < $1.id }))
                }
            }
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }
    
    /**
     Create character filter with given parameters.
     - Parameters:
        - name: The name of the character.
        - status: The species of the character.
        - species: The species of the character.
        - type: The type or subspecies of the character.
        - gender: The species of the character.
     - Returns: CharacterFilter
     */
    func createCharacterFilter(name: String?, status: Status?, species: String?, type: String?, gender: Gender?) -> CharacterFilter {
        
        let parameterDict: [String: String] = [
            "name" : name ?? "",
            "status" : status?.rawValue ?? "",
            "species" : species ?? "",
            "type" : type ?? "",
            "gender" : gender?.rawValue ?? ""
        ]
        
        var query = "character/?"
        for (key, value) in parameterDict {
            if value != "" {
                query.append(key+"="+value+"&")
            }
        }
        
        let filter = CharacterFilter(name: parameterDict["name"]!, status: parameterDict["status"]!, species: parameterDict["species"]!, type: parameterDict["type"]!, gender: parameterDict["gender"]!, query: query)
        return filter
    }
    
    /**
     Request characters with given filter.
     - Parameters:
        - filter: CharacterFilter struct (provides requestURL with query options).
     - Returns: Array of Character model struct.
     */
    public func getCharactersByFilter(filter: CharacterFilter, completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        
        networkHandler.performAPIRequestByMethod(method: filter.query) {
            switch $0 {
            case .success(let data):
            if let infoModel: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(infoModel.results))
            }
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }
    
}

/**
 Struct to store character filter properties.
 ### Properties
    - **name**: The name of the character.
    - **status**: The species of the character.
    - **species**: The species of the character.
    - **type**: The type or subspecies of the character.
    - **gender**: The species of the character.
    - **query**: URL query for HTTP request.
 */
public struct CharacterFilter {
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let query: String
}

/**
 CharacterInfoModel struct for decoding info json response.
 ### Properties
    - **info**: Information about characters count and pagination.
    - **results**: First page with 20 characters.
 
 ### SeeAlso
 - **Info**: Info struct in Network.swift.
 - **CharacterModel**: CharacterModel struct in Character.swift.
 */
struct CharacterInfoModel: Codable {
    let info: Info
    let results: [CharacterModel]
}

/**
 Character struct for decoding character json response.
 ### Properties
    - **id**: The id of the character.
    - **name**: The name of the character.
    - **status**: The status of the character ('Alive', 'Dead' or 'unknown').
    - **species**: The species of the character.
    - **type**: The type or subspecies of the character.
    - **gender**: The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
    - **origin**: Name and link to the character's origin location.
    - **location**: Name and link to the character's last known location endpoint.
    - **image**: Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
    - **episodes**: List of episodes in which this character appeared.
    - **url**: Link to the character's own URL endpoint.
    - **created**: Time at which the character was created in the database.
 */
public struct CharacterModel: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let origin: CharacterOriginModel
    public let location: CharacterLocationModel
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
}

/**
 Origin struct for decoding character json origin response.
 ### Properties
    - **name**: The name of the origin.
    - **url**: Link to the origin's own URL endpoint.
 */
public struct CharacterOriginModel: Codable {
    public let name: String
    public let url: String
}

/**
 Location struct for decoding character location json response.
 ### Properties
    - **name**: The name of the location.
    - **url**: Link to the location's own URL endpoint.
 */
public struct CharacterLocationModel: Codable {
    public let name: String
    public let url: String
}

/**
 Enum to filter by status
 */
public enum Status: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    case none = ""
}

/**
 Enum to filter by gender
 */
public enum Gender: String {
    case female = "female"
    case male = "male"
    case genderless = "genderless"
    case unknown = "unknown"
    case none = ""
}

