//
//  CharacterTests.swift
//  Created by BBruch on 11.04.20.
//

import Combine
import XCTest
@testable import RickMortySwiftApi

final class RMCharacterTests: XCTestCase {
    

    let client = RMClient()
    var cancellable: AnyCancellable?

    func testRequestCharacterByID() async {
        
        let expectation = XCTestExpectation(description: "Request one character by id")
        
        do {
            let character = try await client.character().getCharacterByID(id: 1)
            print("🦸 Character: \(character.name)")
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByIDError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        do {
            _ = try await client.character().getCharacterByID(id: -1)
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByURL() async {
        
        let expectation = XCTestExpectation(description: "Request one character by URL")
        
        do {
            let character = try await client.character().getCharacterByURL(url: "https://rickandmortyapi.com/api/character/1")
            print("🦸 Character: \(character.name)")
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByURLError() async {
        
        let expectation = XCTestExpectation(description: "Request one character by URL")
        
        do {
            _ = try await client.character().getCharacterByURL(url: "https://rickandmortyapi.com/api/character/1234")
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharactersByIDs() async {
        
        let expectation = XCTestExpectation(description: "Request multiple characters by id")
        
        do {
            let characters = try await client.character().getCharactersByIDs(ids: [1,2,3])
            characters.forEach {
                print("🦸 Character: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
    }
    
    func testRequestCharactersByIDsError() async {
        
        let expectation = XCTestExpectation(description: "Request multiple characters by id")
        
        do {
            _ = try await client.character().getCharactersByIDs(ids: [0])
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    
    func testRequestCharactersByPage() async {
        
        let expectation = XCTestExpectation(description: "Request characters by page number")
        
        do {
            let characters = try await client.character().getCharactersByPageNumber(pageNumber: 1)
            characters.forEach {
                print("🦸 Character: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharactersByPageError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        do {
            _ = try await client.character().getCharactersByPageNumber(pageNumber: 1234)
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestAllCharacters() async {
        
        let expectation = XCTestExpectation(description: "Request all characters")
        
        do {
            let characters = try await client.character().getAllCharacters()
            characters.forEach {
                print("🦸 Character: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterCharacters() async {
        
        let expectation = XCTestExpectation(description: "Request characters by filter parameter")
        
        let filter = client.character().createCharacterFilter(name: nil, status: .alive, species: nil, type: nil, gender: .female)
        
        do {
            let characters = try await client.character().getCharactersByFilter(filter: filter)
            characters.forEach {
                print("🦸 Character: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterCharactersError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.character().createCharacterFilter(name: "Test", status: .alive, species: "Test", type: "Test", gender: .female)
        
        do {
            _ = try await client.character().getCharactersByFilter(filter: filter)
           
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    static var allTests = [
        ("testRequestCharacterByID", testRequestCharacterByID),
        ("testRequestCharacterByIDError", testRequestCharacterByIDError),
        ("testRequestCharacterByURL", testRequestCharacterByURL),
        ("testRequestCharacterByURLError", testRequestCharacterByURLError),
        ("testRequestCharacterByPage", testRequestCharactersByPage),
        ("testRequestCharacterByPageError", testRequestCharactersByPageError),
        ("testRequestCharactersByIDs", testRequestCharactersByIDs),
        ("testRequestCharactersByIDsError", testRequestCharactersByIDsError),
        ("testRequestAllCharacters", testRequestAllCharacters),
        ("testRequestFilterCharacters", testRequestFilterCharacters),
        ("testRequestFilterCharactersError", testRequestFilterCharactersError),
    ]
}
