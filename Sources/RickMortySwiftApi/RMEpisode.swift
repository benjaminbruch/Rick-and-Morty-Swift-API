//
//  Episode.swift
//  Created by BBruch on 08.04.20.
//

import Combine
import Foundation

/**
 Episode struct contains all functions to request episode(s) information(s).
 */
public struct RMEpisode {
    
    public init(client: RMClient) {self.client = client}
    
    let client: RMClient
    let networkHandler: NetworkHandler = NetworkHandler()
    
    /**
     Request episode by id.
     - Parameters:
     - id: ID of the episode.
     - Returns: Episode model struct.
     */
    public func getEpisodeByID(id: Int) async throws -> RMEpisodeModel {
        let episodeData = try await networkHandler.performAPIRequestByMethod(method: "episode/"+String(id))
        let episode: RMEpisodeModel = try networkHandler.decodeJSONData(data: episodeData)
        return episode
    }
    
    /**
     Request episode by URL.
     - Parameters:
     - url: URL of the episode.
     - Returns: Episode model struct.
     */
    public func getEpisodeByURL(url: String) async throws-> RMEpisodeModel {
        let episodeData = try await networkHandler.performAPIRequestByURL(url: url)
        let episode: RMEpisodeModel = try networkHandler.decodeJSONData(data: episodeData)
        return episode
    }
    
    /**
     Request multiple episodes by IDs.
     - Parameters:
     - ids: Episodes ids.
     - Returns: Array of episode model struct.
     */
    public func getEpisodesByIDs(ids: [Int]) async throws -> [RMEpisodeModel] {
        let stringIDs = ids.map { String($0) }
        let episodeData = try await networkHandler.performAPIRequestByMethod(method: "episode/"+stringIDs.joined(separator: ","))
        let episodes: [RMEpisodeModel] = try networkHandler.decodeJSONData(data: episodeData)
        return episodes
    }
    
    /**
     Request episodes by page number.
     - Parameters:
     - page: Number of result page.
     - Returns: Array of Episode model struct.
     */
    public func getEpisodesByPageNumber(pageNumber: Int) async throws -> [RMEpisodeModel] {
        let episodeData = try await networkHandler.performAPIRequestByMethod(method: "episode/"+"?page="+String(pageNumber))
        let infoModel: RMEpisodeInfoModel = try networkHandler.decodeJSONData(data: episodeData)
        return infoModel.results
    }
    
    /**
     Request all episodes.
     - Returns: Array of Episode model struct.
     */
    public func getAllEpisodes() async throws ->[RMEpisodeModel] {
        let episodeData = try await networkHandler.performAPIRequestByMethod(method: "episode")
        let infoModel: RMEpisodeInfoModel = try networkHandler.decodeJSONData(data: episodeData)
        let episodes: [RMEpisodeModel] = try await withThrowingTaskGroup(of: [RMEpisodeModel].self) { group in
            for index in 1...infoModel.info.pages {
                group.addTask {
                    let episodeData = try await networkHandler.performAPIRequestByMethod(method: "episode/"+"?page="+String(index))
                    let infoModel: RMEpisodeInfoModel = try networkHandler.decodeJSONData(data: episodeData)
                    return infoModel.results
                }
            }
            
            return try await group.reduce(into: [RMEpisodeModel]()) { allEpisodes, episodes in
                allEpisodes.append(contentsOf: episodes)
            }
        }
        
        return episodes.sorted { $0.id < $1.id }
    }
    
    /**
     Create episode filter with given parameters.
     - Parameters:
     - name: Filter by the given name.
     - episode: Filter by the given episode code.
     - Returns: EpisodeFilter
     */
    func createEpisodeFilter(name: String?, episode: String?) -> RMEpisodeFilter {
        
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
        
        let filter = RMEpisodeFilter(name: parameterDict["name"]!, episode: parameterDict["episode"]!, query: query)
        return filter
    }
    
    /**
     Request episodes with given filter.
     - Parameters:
     - filter: EpisodesFilter struct (provides requestURL with query options).
     - Returns: Array of Episodes model struct.
     */
    public func getEpisodesByFilter(filter: RMEpisodeFilter) async throws -> [RMEpisodeModel] {
        let episodeData = try await networkHandler.performAPIRequestByMethod(method: filter.query)
        let infoModel: RMEpisodeInfoModel = try networkHandler.decodeJSONData(data: episodeData)
        return infoModel.results
    }
}

/**
 Struct to store episode filter properties.
 ### Properties
 - **name**: The name of the episode.
 - **episode**: The code of the episode.
 - **query**: URL query for HTTP request.
 */
public struct RMEpisodeFilter {
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
struct RMEpisodeInfoModel: Codable {
    let info: Info
    let results: [RMEpisodeModel]
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
public struct RMEpisodeModel: Codable, Identifiable {
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



