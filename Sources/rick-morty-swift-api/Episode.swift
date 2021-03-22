//
//  Episode.swift
//  Created by BBruch on 08.04.20.
//

import Combine
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
    public func getEpisodeByID(id: Int) -> Future <EpisodeModel, Error> {
        return Future() { promise in
            networkHandler.performAPIRequestByMethod(method: "episode/"+String(id)) {
                switch $0 {
                case .success(let data):
                    if let episode: EpisodeModel = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(episode))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request episode by URL.
    - Parameters:
        - url: URL of the episode.
    - Returns: Episode model struct.
     */
    public func getEpisodeByURL(url: String) -> Future <EpisodeModel, Error> {
        return Future() { promise in
            networkHandler.performAPIRequestByURL(url: url) {
                switch $0 {
                case .success(let data):
                    if let episode: EpisodeModel = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(episode))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request multiple episodes by IDs.
     - Parameters:
        - ids: Episodes ids.
     - Returns: Array of episode model struct.
     */
    public func getEpisodesByID(ids: [Int]) -> Future <[EpisodeModel], Error> {
        return Future() { promise in
            let stringIDs = ids.map { String($0) }
            networkHandler.performAPIRequestByMethod(method: "episode/"+stringIDs.joined(separator: ",")) {
                switch $0 {
                case .success(let data):
                    if let episodes: [EpisodeModel] = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(episodes))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request episodes by page number.
     - Parameters:
        - page: Number of result page.
     - Returns: Array of Episode model struct.
     */
    public func getEpisodesByPageNumber(pageNumber: Int) -> Future <[EpisodeModel], Error> {
        return Future() { promise in
            networkHandler.performAPIRequestByMethod(method: "episode/"+"?page="+String(pageNumber)) {
                switch $0 {
                case .success(let data):
                    if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(infoModel.results))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request all episodes.
     - Returns: Array of Episode model struct.
     */
    public func getAllEpisodes() -> Future <[EpisodeModel], Error> {
        return Future() { promise in
            var allEpisodes = [EpisodeModel]()
            networkHandler.performAPIRequestByMethod(method: "episode") {
                switch $0 {
                case .success(let data):
                    if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                        allEpisodes = infoModel.results
                        let episodesDispatchGroup = DispatchGroup()
                        
                        for index in 2...infoModel.info.pages {
                            episodesDispatchGroup.enter()
                            
                            networkHandler.performAPIRequestByMethod(method: "episode/"+"?page="+String(index)) {
                                switch $0 {
                                case .success(let data):
                                    if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                                        allEpisodes.append(contentsOf: infoModel.results)
                                        episodesDispatchGroup.leave()
                                    }
                                case .failure(let error):
                                    promise(.failure(error))
                                }
                            }
                        }
                        episodesDispatchGroup.notify(queue: DispatchQueue.main) {
                            promise(.success(allEpisodes.sorted { $0.id < $1.id }))
                        }
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
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
    public func getEpisodesByFilter(filter: EpisodeFilter) -> Future <[EpisodeModel], Error> {
        return Future() { promise in
            
            networkHandler.performAPIRequestByMethod(method: filter.query) {
                switch $0 {
                case .success(let data):
                    if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(infoModel.results))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
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
    public let name: String
    public let episode: String
    public let query: String
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
struct EpisodeInfoModel: Codable {
    let info: Info
    let results: [EpisodeModel]
}

/**
 Episode struct for decoding episode json response.
 ### Properties
 - **id**: The id of the episode.
 - **name**: The name of the episode.
 - **airDate**: The air date of the episode.
 - **episode**: The code of the episode.
 - **characters**: List of characters who have been seen in the episode.
 - **url**: Link to the episode's own endpoint.
 - **created**: Time at which the episode was created in the database.
 */
    public struct EpisodeModel: Codable, Identifiable {
        public let id: Int
        public let name: String
        public let airDate: String
        public let episode: String
        public let characters: [String]
        public let url: String
        public let created: String
        
        enum CodingKeys: String, CodingKey {
            case id, name, episode, characters, url, created
            case airDate = "air_date"
        }
    }
}
