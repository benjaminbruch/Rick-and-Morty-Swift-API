//
//  LocationTests.swift
//  Created by BBruch on 11.04.20.
//

import XCTest
@testable import rick_morty_swift_api

final class LocationTests: XCTestCase {
    
    let client = Client()
    
    func testRequestLocationByID() {
        
        let expectation = XCTestExpectation(description: "Request one location by id")
        
        client.location().getLocationByID(id: 1) {
            switch $0 {
            case .success(let location):
                print(location.name)
                expectation.fulfill()
            case.failure( _):
                break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationByIDError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        client.location().getLocationByID(id: -1) {
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
    
    func testRequestLocationByURL() {
        
        let expectation = XCTestExpectation(description: "Request one location by URL")
        
        client.location().getLocationByURL(url: "https://rickandmortyapi.com/api/location/1") {
            switch $0 {
            case .success(let location):
                print(location.name)
                expectation.fulfill()
            case.failure( _):
                break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationByURLError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for URL")
        
        client.location().getLocationByURL(url: "") {
            switch $0 {
            case .success( _):
                break
            case.failure(let error):
                expectation.fulfill()
                print(error)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByPageNumber() {
        
        let expectation = XCTestExpectation(description: "Request location by page number")
        
        client.location().getLocationsByPageNumber(pageNumber: 1) {
            switch $0 {
            case .success(let locations):
                locations.forEach() { print ($0.name) }
                expectation.fulfill()
            case.failure( _):
                break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByPageNumberError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        client.location().getLocationsByPageNumber(pageNumber: 123) {
            switch $0 {
            case .success( _):
                break
            case.failure(let error):
                expectation.fulfill()
                print(error)
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocations() {
        
        let expectation = XCTestExpectation(description: "Request multiple locations by ids")
        
        client.location().getLocationsByID(ids: [1,2,3]) {
            switch $0 {
            case .success(let locations):
                locations.forEach() { print ($0.name) }
                expectation.fulfill()
            case.failure( _):
                break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestAllLocations() {
        
        let expectation = XCTestExpectation(description: "Request all locations")
        
        client.location().getAllLocations() {
            switch $0 {
            case .success(let locations):
                locations.forEach() { print ($0.name) }
                expectation.fulfill()
            case.failure( _):
                break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterLocations() {
        
        let expectation = XCTestExpectation(description: "Request locations by filter parameter")
        
        let filter = client.location().createLocationFilter(name: "earth", type: nil, dimension: nil)
        
        client.location().getLocationsByFilter(filter: filter) {
            switch $0 {
            case .success(let locations):
                locations.forEach() { print ($0.name) }
                expectation.fulfill()
            case.failure( _):
                break
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterLocationsError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.location().createLocationFilter(name: "Test", type: "Test", dimension: "Test")
        
        client.location().getLocationsByFilter(filter: filter) {
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
    
    static var allTests = [
        ("testRequestLocationByID", testRequestLocationByID),
        ("testRequestLocationByIDError", testRequestLocationByIDError),
        ("testRequestLocationByURL", testRequestLocationByURL),
        ("testRequestLocationByURLError", testRequestLocationByURLError),
        ("testRequestLocations", testRequestLocations),
        ("testRequestLocationsByPageNumber", testRequestLocationsByPageNumber),
        ("testRequestLocationsByPageNumberError", testRequestLocationsByPageNumberError),
        ("testRequestAllLocations", testRequestAllLocations),
        ("testRequestFilterLocations", testRequestFilterLocations),
        ("testRequestFilterLocationsError", testRequestFilterLocationsError),
    ]
}
