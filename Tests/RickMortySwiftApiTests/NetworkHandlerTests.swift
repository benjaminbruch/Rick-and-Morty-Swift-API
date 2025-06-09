//
//  NetworkHandlerTests.swift
//  Created by BBruch on 11.04.20.
//

import XCTest
@testable import RickMortySwiftApi

final class NetworkHandlerTests: XCTestCase {
    
    var networkHandler = NetworkHandler()
    
    func testNetworkRequestByMethod() async {
        
        let expectation = XCTestExpectation(description: "Perform network request with given method")
        
        do {
            let data = try await networkHandler.performRequest(method: "character/1")
            print("Data received: \(data)")
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByMethodError() async {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by method")
        
        do {
            _ = try await networkHandler.performRequest(method: "character/12345")
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByMethodErrorURLError() async {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by method")
        
        networkHandler = NetworkHandler(baseURL: "")
        do {
            _ = try await networkHandler.performRequest(method: "character/1")
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByURL() async {
        
        let expectation = XCTestExpectation(description: "Perform network request with given URL")
        
        do {
            let data = try await networkHandler.performRequest(url: networkHandler.baseURL)
            print("Data received: \(data)")
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByURLInvalidURLError() async {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by URL")
        
        do {
            _ = try await networkHandler.performRequest(url: "")
    
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByURLInvalidResponseError() async {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by URL")
        
        do {
            _ = try await networkHandler.performRequest(url: networkHandler.baseURL + "123")
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
      
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testJSONResponseDataParsing() async {
        
        let expectation = XCTestExpectation(description: "Test decoding data response")
        
        do {
        let data = try await networkHandler.performRequest(url: "https://rickandmortyapi.com/api/character/1")
        let decodedData: RMCharacterModel = try networkHandler.decodeJSONData(data)
        print(decodedData.name)
        expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testJSONResponseDataParsingError() async {
        
        let expectation = XCTestExpectation(description: "Test decoding data response")
        
        do {
            let data = try await networkHandler.performRequest(url: "https://rickandmortyapi.com/api/character/1")
            let _: RMCharacterInfoModel = try networkHandler.decodeJSONData(data)
            } catch (let error) {
                print("⚠️ \(error)")
                expectation.fulfill()
            }
            await fulfillment(of: [expectation], timeout: 10.0)
        }
    
    static let allTests = [
        ("testNetworkRequestByMethod", testNetworkRequestByMethod),
        ("testNetworkRequestByMethodError", testNetworkRequestByMethodError),
        ("testNetworkRequestByMethodErrorURLError", testNetworkRequestByMethodErrorURLError),
        ("testNetworkRequestByURL", testNetworkRequestByURL),
        ("testNetworkRequestByURLInvalidURLError", testNetworkRequestByURLInvalidURLError),
        ("testNetworkRequestByURLInvalidResponseError",testNetworkRequestByURLInvalidResponseError),
        ("testJSONResponseDataParsing", testJSONResponseDataParsing),
        ("testJSONResponseDataParsingError", testJSONResponseDataParsingError),
    ]
}
