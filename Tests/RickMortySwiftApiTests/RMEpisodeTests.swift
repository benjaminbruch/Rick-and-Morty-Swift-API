//
//  EpisodeTests.swift
//  Created by BBruch on 11.04.20.
//

import XCTest
@testable import RickMortySwiftApi

final class RMEpisodeTests: XCTestCase {
    
    let client = RMClient()
    
    func testRequestEpisodeByID() async {
        
        let expectation = XCTestExpectation(description: "Request one episode by ID")
        
        do {
            let episode = try await client.episode().getEpisodeByID(id: 1)
            print("📺 Episode: \(episode.name)")
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByIDError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        do {
            _ = try await client.episode().getEpisodeByID(id: -1)
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByURL() async throws {
        
        let expectation = XCTestExpectation(description: "Request one episode by URL")
        
        do {
            let episode = try await client.episode().getEpisodeByURL(url: "https://rickandmortyapi.com/api/episode/1")
            print("📺 Episode: \(episode.name)")
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodeByURLError() async throws {
        
        let expectation = XCTestExpectation(description: "Test error handling for URL")
        
        do {
            _ = try await client.episode().getEpisodeByURL(url: "https://rickandmortyapi.com/api/episode/1234")
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByIDs() async {
        
        let expectation = XCTestExpectation(description: "Request multiple episodes by IDs")
        
        do {
            let episodes = try await client.episode().getEpisodesByIDs(ids: [1,2,3])
            episodes.forEach {
                print("📺 Episode: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByIDsError() async {
        
        let expectation = XCTestExpectation(description: "Request multiple episodes by IDs")
        
        do {
           _ = try await client.episode().getEpisodesByIDs(ids: [0])
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByPageNumber() async {
        
        let expectation = XCTestExpectation(description: "Request episodes by page number")
        
        do {
            let episodes = try await client.episode().getEpisodesByPageNumber(pageNumber: 1)
            episodes.forEach {
                print("📺 Episode: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestEpisodesByPageNumberError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        do {
            _ = try await client.episode().getEpisodesByPageNumber(pageNumber: 1234)
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestAllEpisodes() async {
        
        let expectation = XCTestExpectation(description: "Request all episodes")
        
        do {
            let episodes = try await client.episode().getAllEpisodes()
            episodes.forEach {
                print("📺 Episode: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterEpisodes() async {
        
        let expectation = XCTestExpectation(description: "Request episodes by filter parameter")
        
        let filter = client.episode().createEpisodeFilter(name: "Pilot", episode: nil)
        
        do {
            let episodes = try await client.episode().getEpisodesByFilter(filter: filter)
            episodes.forEach {
                print("📺 Episode: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterEpisodesError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.episode().createEpisodeFilter(name: "Test", episode: "123")
        
        do {
            _ = try await client.episode().getEpisodesByFilter(filter: filter)
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }

    func testCreateEpisodeFilterQuery() {
        let filter = client.episode().createEpisodeFilter(name: "Pilot", episode: "S01E01")
        XCTAssertEqual(filter.query, "episode/?name=Pilot&episode=S01E01&")
    }

    func testCreateEpisodeFilterQueryNil() {
        let filter = client.episode().createEpisodeFilter(name: nil, episode: nil)
        XCTAssertEqual(filter.query, "episode/?")
    }
    
    static let allTests = [
        ("testRequestEpisodeByID", testRequestEpisodeByID),
        ("testRequestEpisodeByIDError", testRequestEpisodeByIDError),
        ("testRequestEpisodeByURL", testRequestEpisodeByURL),
        ("testRequestEpisodeByURLError", testRequestEpisodeByURLError),
        ("testRequestEpisodesByIDs", testRequestEpisodesByIDs),
        ("testRequestEpisodesByIDsError", testRequestEpisodesByIDsError),
        ("testRequestEpisodesByPageNumber", testRequestEpisodesByPageNumber),
        ("testRequestEpisodesByPageNumberError", testRequestEpisodesByPageNumberError),
        ("testRequestAllEpisodes", testRequestAllEpisodes),
        ("testRequestFilterEpisodes", testRequestFilterEpisodes),
        ("testRequestFilterEpisodesError", testRequestFilterEpisodesError),
        ("testCreateEpisodeFilterQuery", testCreateEpisodeFilterQuery),
        ("testCreateEpisodeFilterQueryNil", testCreateEpisodeFilterQueryNil),
    ]
}
