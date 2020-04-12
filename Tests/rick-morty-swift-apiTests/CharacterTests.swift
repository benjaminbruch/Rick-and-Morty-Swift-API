//
//  CharacterTests.swift
//  Created by BBruch on 11.04.20.
//

import XCTest
@testable import rick_morty_swift_api

final class CharacterTests: XCTestCase {
    
    let client = Client()
    
    func testRequestCharacterByID() {
        
        let expectation = XCTestExpectation(description: "Request one character by id")
        
        client.character().getCharacterByID(id: 1) {result in switch result {
        case .success(let character):
            print(character.name)
            expectation.fulfill()
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByIDError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        client.character().getCharacterByID(id: -1) {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByURL() {
        
        let expectation = XCTestExpectation(description: "Request one character by URL")
        
        client.character().getCharacterByURL(url: "https://rickandmortyapi.com/api/character/1") {result in switch result {
        case .success(let character):
            print(character.name)
            expectation.fulfill()
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharacterByURLError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for URL")
        
        client.character().getCharacterByURL(url: "") {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
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
        case.failure( _):
            break
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
        case .failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestCharactersByPageError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        client.character().getCharactersByPageNumber(pageNumber: 123) {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
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
        case.failure( _):
            break
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
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterCharactersError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.character().createCharacterFilter(name: "Test", status: .alive, species: "Test", type: "Test", gender: .female)
        
        client.character().getCharactersByFilter(filter: filter) {result in switch result {
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
        ("testRequestCharacterByID", testRequestCharacterByID),
        ("testRequestCharacterByIDError", testRequestCharacterByIDError),
        ("testRequestCharacterByURL", testRequestCharacterByURL),
        ("testRequestCharacterByURLError", testRequestCharacterByURLError),
        ("testRequestCharacterByPage", testRequestCharactersByPage),
        ("testRequestCharacterByPageError", testRequestCharactersByPageError),
        ("testRequestCharacters", testRequestCharacters),
        ("testRequestAllCharacters", testRequestAllCharacters),
        ("testRequestFilterCharacters", testRequestFilterCharacters),
        ("testRequestFilterCharactersError", testRequestFilterCharactersError),
    ]
}
