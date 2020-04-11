//
//  EpisodeTests.swift
//  Created by BBruch on 11.04.20.
//

import XCTest
@testable import rick_morty_swift_api

final class EpisodeTests: XCTestCase {
    
    let client = Client()
    
    func testRequestEpisodeByID() {
        
        let expectation = XCTestExpectation(description: "Request one episode by ID")
        
        client.episode().getEpisodeByID(id: 1) {result in switch result {
        case .success(let episode):
            print(episode.name)
            expectation.fulfill()
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByIDError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        client.episode().getEpisodeByID(id: -1) {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
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
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByURLError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for URL")
        
        client.episode().getEpisodeByURL(url: "") {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
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
        case.failure( _):
            break
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
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByPageNumberError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        client.episode().getEpisodesByPageNumber(pageNumber: 123) {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
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
        case.failure( _):
            break
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
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterEpisodesError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.episode().createEpisodeFilter(name: "Test", episode: "123")
        
        client.episode().getEpisodesByFilter(filter: filter) {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    static var allTests = [
        ("testRequestEpisodeByID", testRequestEpisodeByID),
        ("testRequestEpisodeByID", testRequestEpisodeByIDError),
        ("testRequestEpisodeByURL", testRequestEpisodeByURL),
        ("testRequestEpisodeByURLError", testRequestEpisodeByURLError),
        ("testRequestEpisodesByIDs", testRequestEpisodesByIDs),
        ("testRequestEpisodesByPageNumber", testRequestEpisodesByPageNumber),
        ("testRequestEpisodesByPageNumberError", testRequestEpisodesByPageNumberError),
        ("testRequestAllEpisodes", testRequestAllEpisodes),
        ("testRequestFilterEpisodes", testRequestFilterEpisodes),
        ("testRequestFilterEpisodesError", testRequestFilterEpisodesError),
    ]
}
