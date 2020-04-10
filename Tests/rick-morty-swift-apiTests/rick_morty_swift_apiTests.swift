import XCTest
@testable import rick_morty_swift_api

final class rick_morty_api_swiftTests: XCTestCase {
    
    let client = Client()
    
    // MARK: Test character struct
    func testRequestCharacterByID() {
        
        let expectation = XCTestExpectation(description: "Request one character by id")
        
        client.character().getCharacterByID(id: 1) {result in switch result {
        case .success(let character):
            print(character.name)
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByURL() {
        
        let expectation = XCTestExpectation(description: "Request one character by id")
        
        client.character().getCharacterByURL(url: "https://rickandmortyapi.com/api/character/1") {result in switch result {
        case .success(let character):
            print(character.name)
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    
    func testRequestCharacters() {
        
        let expectation = XCTestExpectation(description: "Request multiple characters by id")
        
        client.character().getCharactersByID(ids: [1,2,3]) {result in switch result {
        case .success(let characters):
            characters.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharactersByPage() {
        
        let expectation = XCTestExpectation(description: "Request characters by page number")
        
        client.character().getCharactersByPageNumber(pageNumber: 1) {result in switch result {
        case .success(let characters):
            characters.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestAllCharacters() {
        
        let expectation = XCTestExpectation(description: "Request all characters")
        
        client.character().getAllCharacters() {result in switch result {
        case .success(let characters):
            characters.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterCharacters() {
        
        let expectation = XCTestExpectation(description: "Request characters by filter parameter")
        
        let filter = client.character().createCharacterFilter(name: nil, status: .alive, species: nil, type: nil, gender: .female)
        
        client.character().getCharactersByFilter(filter: filter) {result in switch result {
        case .success(let characters):
            characters.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: Test location struct
    func testRequestLocationByID() {
        
        let expectation = XCTestExpectation(description: "Request one location by id")
        
        client.location().getLocationByID(id: 1) {result in switch result {
        case .success(let location):
            print(location.name)
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationByURL() {
        
        let expectation = XCTestExpectation(description: "Request one location by url")
        
        client.location().getLocationByURL(url: "https://rickandmortyapi.com/api/location/1") {result in switch result {
        case .success(let location):
            print(location.name)
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByPageNumber() {
        
        let expectation = XCTestExpectation(description: "Request location by page number")
        
        client.location().getLocationsByPageNumber(pageNumber: 1) {result in switch result {
        case .success(let locations):
            locations.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocations() {
        
        let expectation = XCTestExpectation(description: "Request multiple locations by ids")
        
        client.location().getLocationsByID(ids: [1,2,3]) {result in switch result {
        case .success(let locations):
            locations.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestAllLocations() {
        
        let expectation = XCTestExpectation(description: "Request all locations")
        
        client.location().getAllLocations() {result in switch result {
        case .success(let locations):
            locations.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterLocations() {
        
        let expectation = XCTestExpectation(description: "Request locations by filter parameter")
        
        let filter = client.location().createLocationFilter(name: "earth", type: nil, dimension: nil)
        
        client.location().getLocationsByFilter(filter: filter) {result in switch result {
        case .success(let locations):
            locations.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByID() {
        
        let expectation = XCTestExpectation(description: "Request one episode by ID")
        
        client.episode().getEpisodeByID(id: 1) {result in switch result {
        case .success(let episode):
            print(episode.name)
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByURL() {
        
        let expectation = XCTestExpectation(description: "Request one episode by URL")
        
        client.episode().getEpisodeByURL(url: "https://rickandmortyapi.com/api/episode/1") {result in switch result {
        case .success(let episode):
            print(episode.name)
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByIDs() {
        
        let expectation = XCTestExpectation(description: "Request multiple episodes by IDs")
        
        client.episode().getEpisodesByID(ids: [1,2,3]) {result in switch result {
        case .success(let episodes):
            episodes.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByPageNumber() {
        
        let expectation = XCTestExpectation(description: "Request episodes by page number")
        
        client.episode().getEpisodesByPageNumber(pageNumber: 1) {result in switch result {
        case .success(let episodes):
            episodes.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestAllEpisodes() {
        
        let expectation = XCTestExpectation(description: "Request all episodes")
        
        client.episode().getAllEpisodes() {result in switch result {
        case .success(let episodes):
            episodes.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterEpisodes() {
        
        let expectation = XCTestExpectation(description: "Request episodes by filter parameter")
        
        let filter = client.episode().createEpisodeFilter(name: "Pilot", episode: nil)
        
        client.episode().getEpisodesByFilter(filter: filter) {result in switch result {
        case .success(let episodes):
            episodes.forEach() { print ($0.name) }
            expectation.fulfill()
        case.failure(let error):
            print(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    static var allTests = [
        ("testRequestCharacterByID", testRequestCharacterByID),
        ("testRequestCharacterByURL", testRequestCharacterByURL),
        ("testRequestCharacterByPage", testRequestCharactersByPage),
        ("testRequestCharacters", testRequestCharacters),
        ("testRequestAllCharacters", testRequestAllCharacters),
        ("testRequestFilterCharacters", testRequestFilterCharacters),
        ("testRequestLocationByID", testRequestLocationByID),
        ("testRequestLocationByURL", testRequestLocationByURL),
        ("testRequestLocations", testRequestLocations),
        ("testRequestAllLocations", testRequestAllLocations),
        ("testRequestFilterLocations", testRequestFilterLocations),
        ("testRequestEpisodeByID", testRequestEpisodeByID),
        ("testRequestEpisodeByURL", testRequestEpisodeByURL),
        ("testRequestEpisodesByIDs", testRequestEpisodesByIDs),
        ("testRequestEpisodesByPageNumber", testRequestEpisodesByPageNumber),
        ("testRequestAllEpisodes", testRequestAllEpisodes),
        ("testRequestFilterEpisodes", testRequestFilterEpisodes),
    ]
}
