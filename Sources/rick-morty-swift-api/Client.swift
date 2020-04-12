//
//  Client.swift
//  Created by BBruch on 08.04.20.
//

import Foundation

/**
 API Client for Rick and Morty API.
 */
public struct Client {
    
    /**
     Access character struct.
     - Returns: Character struct.
     */
    public func character() -> Character {
        let character = Character(client: self)
        return character
    }
    
    /**
     Access episode struct.
     - Returns: Episode struct.
     */
    public func episode() -> Episode {
        let episode = Episode(client: self)
        return episode
    }
    
    /**
     Access location struct.
     - Returns: Location struct.
     */
    public func location() -> Location {
        let location = Location(client: self)
        return location
    }
}




