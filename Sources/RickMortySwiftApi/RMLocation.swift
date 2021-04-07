//
//  Location.swift
//  Created by BBruch on 08.04.20.
//

import Combine
import Foundation

/**
 Location struct contains all functions to request location(s) information(s).
 */
public struct RMLocation {
    
    public init(client: RMClient) {self.client = client}
    
    let client: RMClient
    let networkHandler: NetworkHandler = NetworkHandler()
    
    /**
     Request loaction by id.
     - Parameters:
     - id: ID of the location.
     - Returns: Location model struct.
     */
    public func getLocationByID(id: Int) -> Future <RMLocationModel, Error> {
        return Future() { promise in
            networkHandler.performAPIRequestByMethod(method: "location/"+String(id)) {
                switch $0 {
                case .success(let data):
                    if let location: RMLocationModel = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(location))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request loaction by URL.
     - Parameters:
     - url: URL of the location.
     - Returns: Location model struct.
     */
    public func getLocationByURL(url: String) -> Future <RMLocationModel, Error> {
        return Future() { promise in
            networkHandler.performAPIRequestByURL(url: url) {
                switch $0 {
                case .success(let data):
                    if let location: RMLocationModel = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(location))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request multiple locations by IDs.
     - Parameters:
     - ids: Location ids.
     - Returns: Array of location model struct.
     */
    public func getLocationsByID(ids: [Int]) -> Future <[RMLocationModel], Error> {
        return Future() { promise in
            let stringIDs = ids.map { String($0) }
            networkHandler.performAPIRequestByMethod(method: "location/"+stringIDs.joined(separator: ",")) {
                switch $0 {
                case .success(let data):
                    if let locations: [RMLocationModel] = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(locations))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request loactions by page number.
     - Parameters:
     - page: Number of result page.
     - Returns: Array of Location model struct.
     */
    public func getLocationsByPageNumber(pageNumber: Int) -> Future <[RMLocationModel], Error> {
        return Future() { promise in
            networkHandler.performAPIRequestByMethod(method: "location/"+"?page="+String(pageNumber)) {
                switch $0 {
                case .success(let data):
                    if let infoModel: RMLocationInfoModel = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(infoModel.results))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request all locations.
     - Returns: Array of Location model struct.
     */
    public func getAllLocations() -> Future <[RMLocationModel], Error> {
        return Future() { promise in
            var allLocations = [RMLocationModel]()
            networkHandler.performAPIRequestByMethod(method: "location") {
                switch $0 {
                case .success(let data):
                    if let infoModel: RMLocationInfoModel = self.networkHandler.decodeJSONData(data: data) {
                        allLocations = infoModel.results
                        let locationsDispatchGroup = DispatchGroup()
                        
                        for index in 2...infoModel.info.pages {
                            locationsDispatchGroup.enter()
                            
                            networkHandler.performAPIRequestByMethod(method: "location/"+"?page="+String(index)) {
                                switch $0 {
                                case .success(let data):
                                    if let infoModel: RMLocationInfoModel = self.networkHandler.decodeJSONData(data: data) {
                                        allLocations.append(contentsOf: infoModel.results)
                                        locationsDispatchGroup.leave()
                                    }
                                case .failure(let error):
                                    promise(.failure(error))
                                }
                            }
                        }
                        locationsDispatchGroup.notify(queue: DispatchQueue.main) {
                            promise(.success(allLocations.sorted { $0.id < $1.id }))
                        }
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Create location filter with given parameters.
     - Parameters:
     - name: The name of the location.
     - type: The type or the location.
     - dimension: The dimension of the location.
     - Returns: LocationFilter
     */
    func createLocationFilter(name: String?, type: String?, dimension: String?) -> RMLocationFilter {
        
        let parameterDict: [String: String] = [
            "name" : name ?? "",
            "type" : type ?? "",
            "dimension" : dimension ?? ""
        ]
        
        var query = "location/?"
        for (key, value) in parameterDict {
            if value != "" {
                query.append(key+"="+value+"&")
            }
        }
        
        let filter = RMLocationFilter(name: parameterDict["name"]!, type: parameterDict["type"]!, dimension: parameterDict["dimension"]!, query: query)
        return filter
    }
    
    /**
     Request locations with given filter.
     - Parameters:
     - filter: LocationFilter struct (provides requestURL with query options).
     - Returns: Array of Location model struct.
     */
    public func getLocationsByFilter(filter: RMLocationFilter) -> Future <[RMLocationModel], Error> {
        return Future() { promise in
            
            networkHandler.performAPIRequestByMethod(method: filter.query) {
                switch $0 {
                case .success(let data):
                    if let infoModel: RMLocationInfoModel = self.networkHandler.decodeJSONData(data: data) {
                        promise(.success(infoModel.results))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        
    }
    
    /**
     Struct to store location filter properties.
     ### Properties
     - **name**: The name of the location.
     - **type**: The type of the location.
     - **dimension**: The dimension of the location.
     - **query**: URL query for HTTP request.
     */
    public struct RMLocationFilter {
        public let name: String
        public let type: String
        public let dimension: String
        public let query: String
    }
    
    /**
     LocationInfoModel struct for decoding info json response.
     ### Properties
     - **info**: Information about location count and pagination.
     - **results**: First page with 20 locations.
     
     ### SeeAlso
     - **Info**: Info struct in Network.swift.
     - **LocationModel**: LocationModel struct in Location.swift.
     */
    struct RMLocationInfoModel: Codable {
        let info: Info
        let results: [RMLocationModel]
    }
    
    /**
     Episode struct for decoding episode json response.
     ### Properties
     - **id**: The id of the location.
     - **name**: The name of the location.
     - **type**: The type of the location.
     - **dimension**: The dimension in which the location is located.
     - **residents**: List of location who have been last seen in the location.
     - **url**: Link to location's own endpoint.
     - **created**: Time at which the location was created in the database.
     */
    public struct RMLocationModel: Codable, Identifiable  {
        public let id: Int
        public let name: String
        public let type: String
        public let dimension: String
        public let residents: [String]
        public let url: String
        public let created: String
    }
}
