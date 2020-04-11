//
//  NetworkHandlerTests.swift
//  Created by BBruch on 11.04.20.
//

import XCTest
@testable import rick_morty_swift_api

final class NetworkHandlerTests: XCTestCase {
    
    let networkHandler = NetworkHandler()
    
    func testNetworkRequestByMethod() {
        
        let expectation = XCTestExpectation(description: "Perform network request with given method")
        
        networkHandler.performAPIRequestByMethod(method: "character/1") {result in switch result {
        case .success( _):
            print("Data received")
            expectation.fulfill()
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByMethodError() {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by method")
        
        networkHandler.performAPIRequestByMethod(method: "123") {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByURL() {
        
        let expectation = XCTestExpectation(description: "Perform network request with given URL")
        
        networkHandler.performAPIRequestByURL(url: networkHandler.baseURL) {result in switch result {
        case .success( _):
            print("Data received")
            expectation.fulfill()
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByURLError() {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by method")
        
        networkHandler.performAPIRequestByURL(url: "") {result in switch result {
        case .success( _):
            break
        case.failure(let error):
            print(error)
            expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testJSONResponseDataParsing() {
        
        let expectation = XCTestExpectation(description: "Test decoding data response")
        
        networkHandler.performAPIRequestByURL(url: "https://rickandmortyapi.com/api/character/1") {result in switch result {
        case .success(let data):
            if let decodedData: CharacterModel = self.networkHandler.decodeJSONData(data: data) {
                print(decodedData.name)
                expectation.fulfill()
            }
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testJSONResponseDataParsingError() {
        
        let expectation = XCTestExpectation(description: "Test decoding data response")
        
        networkHandler.performAPIRequestByURL(url: "https://rickandmortyapi.com/api/character/1") {result in switch result {
        case .success(let data):
            if let decodedData: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                print(decodedData.info.count)
                print("decoding successful")
            } else {
                print("decoding failed")
                expectation.fulfill()
            }
        case.failure( _):
            break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    static var allTests = [
        ("testNetworkRequestByMethod", testNetworkRequestByMethod),
        ("testNetworkRequestByMethodError", testNetworkRequestByMethodError),
        ("testNetworkRequestByURL", testNetworkRequestByURL),
        ("testNetworkRequestByURLError", testNetworkRequestByURLError),
        ("testJSONResponseDataParsing", testJSONResponseDataParsing),
        ("testJSONResponseDataParsingError", testJSONResponseDataParsingError),
    ]
}
