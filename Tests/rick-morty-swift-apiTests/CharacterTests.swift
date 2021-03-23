//
//  CharacterTests.swift
//  Created by BBruch on 11.04.20.
//

import Combine
import XCTest
@testable import rick_morty_swift_api

final class CharacterTests: XCTestCase {
    

    let client = RMClient()
    var cancellable: AnyCancellable?

    func testRequestCharacterByID() {
        
        let expectation = XCTestExpectation(description: "Request one character by id")
        
        cancellable = client.character().getCharacterByID(id: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { character in
                print(character.name)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByIDError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        cancellable = client.character().getCharacterByID(id: -1)
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
    
    func testRequestCharacterByURL() {
        
        let expectation = XCTestExpectation(description: "Request one character by URL")
        
        cancellable = client.character().getCharacterByURL(url: "https://rickandmortyapi.com/api/character/1")
            .sink(receiveCompletion: { _ in }, receiveValue: { character in
                print(character.name)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByURLError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for URL")
        
        cancellable = client.character().getCharacterByURL(url: "")
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
    
    func testRequestCharactersByIDs() {
        
        let expectation = XCTestExpectation(description: "Request multiple characters by id")
        
        cancellable = client.character().getCharactersByID(ids: [1,2,3])
            .sink(receiveCompletion: { _ in }, receiveValue: { characters in
                characters.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharactersByIDsError() {
        
        let expectation = XCTestExpectation(description: "Request multiple characters by id")
        
        cancellable = client.character().getCharactersByID(ids: [0])
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
    
    
    
    func testRequestCharactersByPage() {
        
        let expectation = XCTestExpectation(description: "Request characters by page number")
        
        cancellable = client.character().getCharactersByPageNumber(pageNumber: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { characters in
                characters.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharactersByPageError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        cancellable = client.character().getCharactersByPageNumber(pageNumber: 123)
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
    
    func testRequestAllCharacters() {
        
        let expectation = XCTestExpectation(description: "Request all characters")
        
        cancellable = client.character().getAllCharacters()
            .sink(receiveCompletion: { _ in }, receiveValue: { characters in
                characters.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterCharacters() {
        
        let expectation = XCTestExpectation(description: "Request characters by filter parameter")
        
        let filter = client.character().createCharacterFilter(name: nil, status: .alive, species: nil, type: nil, gender: .female)
        
        cancellable = client.character().getCharactersByFilter(filter: filter)
            .sink(receiveCompletion: { _ in }, receiveValue: { characters in
                characters.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterCharactersError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.character().createCharacterFilter(name: "Test", status: .alive, species: "Test", type: "Test", gender: .female)
        
        
        cancellable = client.character().getCharactersByFilter(filter: filter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher finished")
                case .failure(let error):
                    print(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
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
