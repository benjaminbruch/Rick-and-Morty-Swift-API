//
//  LocationTests.swift
//  Created by BBruch on 11.04.20.
//

import XCTest
@testable import RickMortySwiftApi

final class RMLocationTests: XCTestCase {
    

    let client = RMClient()

    func testRequestLocationByID() async {
        
        let expectation = XCTestExpectation(description: "Request one location by id")
        
      
        do {
            let location = try await client.location().getLocationByID(id: 1)
            print("🌎 Location: \(location.name)")
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationByIDError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        do {
           _ = try await client.location().getLocationByID(id: -1)
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationByURL() async {
        
        let expectation = XCTestExpectation(description: "Request one location by URL")
        
        do {
            let location = try await client.location().getLocationByURL(url: "https://rickandmortyapi.com/api/location/1")
            print("🌎 Location: \(location.name)")
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationByURLError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for URL")
        
        do {
          _ = try await client.location().getLocationByURL(url: "")
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByPageNumber() async {
        
        let expectation = XCTestExpectation(description: "Request location by page number")
        
        do {
            let locations = try await client.location().getLocationsByPageNumber(pageNumber: 1)
            locations.forEach {
                print("🌎 Location: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByPageNumberError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        do {
            _ = try await client.location().getLocationsByPageNumber(pageNumber: 1234)
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByIDs() async {
        
        let expectation = XCTestExpectation(description: "Request multiple locations by ids")
        
        do {
            let locations = try await client.location().getLocationsByIDs(ids: [1,2,3])
            locations.forEach {
                print("🌎 Location: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByIDsError() async {
        
        let expectation = XCTestExpectation(description: "Request multiple locations by ids")
        
        do {
            _ = try await client.location().getLocationsByIDs(ids: [-1])
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestAllLocations() async {
        
        let expectation = XCTestExpectation(description: "Request all locations")
        
        do {
            let locations = try await client.location().getAllLocations()
            locations.forEach {
                print("🌎 Location: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterLocations() async {
        
        let expectation = XCTestExpectation(description: "Request locations by filter parameter")
        
        let filter = client.location().createLocationFilter(name: "earth", type: nil, dimension: nil)
        
        do {
            let locations = try await client.location().getLocationsByFilter(filter: filter)
            locations.forEach {
                print("🌎 Location: \($0.name)")
            }
            expectation.fulfill()
        } catch (let error) {
            print("⚠️ \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterLocationsError() async {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.location().createLocationFilter(name: "Test", type: "Test", dimension: "Test")
        do {
            _ = try await client.location().getLocationsByFilter(filter: filter)
        } catch (let error) {
            print("⚠️ \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    static let allTests = [
        ("testRequestLocationByID", testRequestLocationByID),
        ("testRequestLocationByIDError", testRequestLocationByIDError),
        ("testRequestLocationByURL", testRequestLocationByURL),
        ("testRequestLocationByURLError", testRequestLocationByURLError),
        ("testRequestLocationsByIDs", testRequestLocationsByIDs),
        ("testRequestLocationsByIDsError", testRequestLocationsByIDsError),
        ("testRequestLocationsByPageNumber", testRequestLocationsByPageNumber),
        ("testRequestLocationsByPageNumberError", testRequestLocationsByPageNumberError),
        ("testRequestAllLocations", testRequestAllLocations),
        ("testRequestFilterLocations", testRequestFilterLocations),
        ("testRequestFilterLocationsError", testRequestFilterLocationsError),
    ]
}
