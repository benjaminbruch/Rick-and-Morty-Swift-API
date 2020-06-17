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
        
        networkHandler.performAPIRequestByMethod(method: "character/1") {
            switch $0 {
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
        
        networkHandler.performAPIRequestByMethod(method: "character/1234") {
            switch $0 {
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
        
        networkHandler.performAPIRequestByURL(url: networkHandler.baseURL) {
            switch $0 {
            case .success( _):
                print("Data received")
                expectation.fulfill()
            case.failure( _):
                break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByURLInvalidURLError() {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by URL")
        
        networkHandler.performAPIRequestByURL(url: "") {
            switch $0 {
            case .success( _):
                break
            case.failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByURLInvalidResponseError() {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by URL")
        
        networkHandler.performAPIRequestByURL(url: networkHandler.baseURL+"123") {
            switch $0 {
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
        
        networkHandler.performAPIRequestByURL(url: "https://rickandmortyapi.com/api/character/1") {
            switch $0 {
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
        
        networkHandler.performAPIRequestByURL(url: "https://rickandmortyapi.com/api/character/1") {
            switch $0 {
            case .success(let data):
                if let _: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
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
        ("testNetworkRequestByURLInvalidURLError", testNetworkRequestByURLInvalidURLError),
        ("testNetworkRequestByURLInvalidResponseError",testNetworkRequestByURLInvalidResponseError),
        ("testJSONResponseDataParsing", testJSONResponseDataParsing),
        ("testJSONResponseDataParsingError", testJSONResponseDataParsingError),
    ]
}
