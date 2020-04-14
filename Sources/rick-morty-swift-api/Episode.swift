//
//  Episode.swift
//  Created by BBruch on 08.04.20.
//

import Foundation

/**
Episode struct contains all functions to request episode(s) information(s).
*/
public struct Episode {
    
    public init(client: Client) {self.client = client}
    
    let client: Client
    let networkHandler: NetworkHandler = NetworkHandler()
    
    /**
     Request episode by id.
    - Parameters:
        - id: ID of the episode.
        - Returns: Episode model struct.
     */
    public func getEpisodeByID(id: Int, completion: @escaping (Result<EpisodeModel, Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "episode/"+String(id)) {result in switch result {
        case .success(let data):
            if let episode: EpisodeModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(episode))
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
    
    /**
     Request episode by URL.
    - Parameters:
        - url: URL of the episode.
    - Returns: Episode model struct.
     */
    public func getEpisodeByURL(url: String, completion: @escaping (Result<EpisodeModel, Error>) -> Void) {
        networkHandler.performAPIRequestByURL(url: url) {result in switch result {
        case .success(let data):
            if let episode: EpisodeModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(episode))
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
    
    /**
     Request multiple episodes by IDs.
     - Parameters:
        - ids: Episodes ids.
     - Returns: Array of episode model struct.
     */
    public func getEpisodesByID(ids: [Int], completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        let stringIDs = ids.map { String($0) }
        networkHandler.performAPIRequestByMethod(method: "episode/"+stringIDs.joined(separator: ",")) {result in switch result {
        case .success(let data):
            if let episodes: [EpisodeModel] = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(episodes))
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
    
    /**
     Request episodes by page number.
     - Parameters:
        - page: Number of result page.
     - Returns: Array of Episode model struct.
     */
    public func getEpisodesByPageNumber(pageNumber: Int, completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "episode/"+"?page="+String(pageNumber)) {result in switch result {
        case .success(let data):
            if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(infoModel.results))
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
    
    /**
     Request all episodes.
     - Returns: Array of Episode model struct.
     */
    public func getAllEpisodes(completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        var allEpisodes = [EpisodeModel]()
        networkHandler.performAPIRequestByMethod(method: "episode") {result in switch result {
        case .success(let data):
            if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                allEpisodes = infoModel.results
                let episodesDispatchGroup = DispatchGroup()
                
                for index in 2...infoModel.info.pages {
                    episodesDispatchGroup.enter()
                    self.getEpisodesByPageNumber(pageNumber: index) {result in switch result {
                    case .success(let episodes):
                        allEpisodes.append(contentsOf:episodes)
                        episodesDispatchGroup.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        }}
                }
                episodesDispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(.success(allEpisodes.sorted { $0.id < $1.id }))
                }
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
    
    /**
     Create episode filter with given parameters.
     - Parameters:
        - name: Filter by the given name.
        - episode: Filter by the given episode code.
     - Returns: EpisodeFilter
     */
    func createEpisodeFilter(name: String?, episode: String?) -> EpisodeFilter {
        
        let parameterDict: [String: String] = [
            "name" : name ?? "",
            "episode" : episode ?? ""
        ]
        
        var query = "episode/?"
        for (key, value) in parameterDict {
            if value != "" {
                query.append(key+"="+value+"&")
            }
        }
        
        let filter = EpisodeFilter(name: parameterDict["name"]!, episode: parameterDict["episode"]!, query: query)
        return filter
    }
    
    /**
     Request episodes with given filter.
     - Parameters:
        - filter: EpisodesFilter struct (provides requestURL with query options).
     - Returns: Array of Episodes model struct.
     */
    public func getEpisodesByFilter(filter: EpisodeFilter, completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        
        networkHandler.performAPIRequestByMethod(method: filter.query) {result in switch result {
        case .success(let data):
            if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(infoModel.results))
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
}

/**
 Struct to store episode filter properties.
 ### Properties
 - **name**: The name of the episode.
 - **episode**: The code of the episode.
 - **query**: URL query for HTTP request.
 */
public struct EpisodeFilter {
    let name: String
    let episode: String
    let query: String
}

/**
 EpisodeInfoModel struct for decoding info json response.
 ### Properties
 - **info**: Information about episode count and pagination.
 - **results**: First page with 20 episodes.
 
 ### SeeAlso
 - **Info**: Info struct in Network.swift.
 - **EpisodeModel**: EpisodeModel struct in Episode.swift.
 */
public struct EpisodeInfoModel: Codable {
    let info: Info
    let results: [EpisodeModel]
}

/**
 Episode struct for decoding episode json response.
 ### Properties
 - **id**: The id of the episode.
 - **name**: The name of the episode.
 - **airdDate**: The air date of the episode.
 - **episode**: The code of the episode.
 - **characters**: List of characters who have been seen in the episode.
 - **url**: Link to the episode's own endpoint.
 - **created**: Time at which the episode was created in the database.
 */
public struct EpisodeModel: Codable, Identifiable {
    public let id: Int
    let name: String
    let airDate: String = "air_date"
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
