//
//  EpisodeTests.swift
//  Created by BBruch on 11.04.20.
//

import Combine
import XCTest
@testable import rick_morty_swift_api

final class uts: XCTestCase {
    
    let client = RMClient()
    var cancellable: AnyCancellable?
    
    func testRequestEpisodeByID() {
        
        let expectation = XCTestExpectation(description: "Request one episode by ID")
        
        cancellable = client.episode().getEpisodeByID(id: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { episode in
                print(episode.name)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByIDError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        cancellable = client.episode().getEpisodeByID(id: -1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher finished")
                case .failure(let error):
                    print(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByURL() {
        
        let expectation = XCTestExpectation(description: "Request one episode by URL")
        
        cancellable = client.episode().getEpisodeByURL(url: "https://rickandmortyapi.com/api/episode/1")
            .sink(receiveCompletion: { _ in }, receiveValue: { episode in
                print(episode.name)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByURLError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for URL")
        
        cancellable = client.episode().getEpisodeByURL(url: "")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher finished")
                case .failure(let error):
                    print(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByIDs() {
        
        let expectation = XCTestExpectation(description: "Request multiple episodes by IDs")
        
        cancellable = client.episode().getEpisodesByID(ids: [1,2,3])
            .sink(receiveCompletion: { _ in }, receiveValue: { episodes in
                episodes.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByIDsError() {
        
        let expectation = XCTestExpectation(description: "Request multiple episodes by IDs")
        
        cancellable = client.episode().getEpisodesByID(ids: [0])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher finished")
                case .failure(let error):
                    print(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByPageNumber() {
        
        let expectation = XCTestExpectation(description: "Request episodes by page number")
        
        cancellable = client.episode().getEpisodesByPageNumber(pageNumber: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { episodes in
                episodes.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByPageNumberError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        cancellable = client.episode().getEpisodesByPageNumber(pageNumber: 123)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher finished")
                case .failure(let error):
                    print(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestAllEpisodes() {
        
        let expectation = XCTestExpectation(description: "Request all episodes")
        
        cancellable = client.episode().getAllEpisodes()
            .sink(receiveCompletion: { _ in }, receiveValue: { episodes in
                episodes.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterEpisodes() {
        
        let expectation = XCTestExpectation(description: "Request episodes by filter parameter")
        
        let filter = client.episode().createEpisodeFilter(name: "Pilot", episode: nil)
        
        cancellable = client.episode().getEpisodesByFilter(filter: filter)
            .sink(receiveCompletion: { _ in }, receiveValue: { episodes in
                episodes.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterEpisodesError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.episode().createEpisodeFilter(name: "Test", episode: "123")
        
        cancellable = client.episode().getEpisodesByFilter(filter: filter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher finished")
                case .failure(let error):
                    print(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
        wait(for: [expectation], timeout: 10.0) 
    }
    
    static var allTests = [
        ("testRequestEpisodeByID", testRequestEpisodeByID),
        ("testRequestEpisodeByID", testRequestEpisodeByIDError),
        ("testRequestEpisodeByURL", testRequestEpisodeByURL),
        ("testRequestEpisodeByURLError", testRequestEpisodeByURLError),
        ("testRequestEpisodesByIDs", testRequestEpisodesByIDs),
        ("testRequestEpisodesByIDsError", testRequestEpisodesByIDsError),
        ("testRequestEpisodesByPageNumber", testRequestEpisodesByPageNumber),
        ("testRequestEpisodesByPageNumberError", testRequestEpisodesByPageNumberError),
        ("testRequestAllEpisodes", testRequestAllEpisodes),
        ("testRequestFilterEpisodes", testRequestFilterEpisodes),
        ("testRequestFilterEpisodesError", testRequestFilterEpisodesError),
    ]
}
