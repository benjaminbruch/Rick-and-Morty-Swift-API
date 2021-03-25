//
//  LocationTests.swift
//  Created by BBruch on 11.04.20.
//

import Combine
import XCTest
@testable import RickMortySwiftApi

final class RMLocationTests: XCTestCase {
    

    let client = RMClient()
    var cancellable: AnyCancellable?

    func testRequestLocationByID() {
        
        let expectation = XCTestExpectation(description: "Request one location by id")
        
        cancellable = client.location().getLocationByID(id: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { location in
                print(location.name)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0) 
    }
    
    func testRequestLocationByIDError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for id")
        
        cancellable = client.location().getLocationByID(id: -1)
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
    
    func testRequestLocationByURL() {
        
        let expectation = XCTestExpectation(description: "Request one location by URL")
        
        cancellable = client.location().getLocationByURL(url: "https://rickandmortyapi.com/api/location/1")
            .sink(receiveCompletion: { _ in }, receiveValue: { location in
                print(location.name)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationByURLError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for URL")
        
        cancellable = client.location().getLocationByURL(url: "")
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
    
    func testRequestLocationsByPageNumber() {
        
        let expectation = XCTestExpectation(description: "Request location by page number")
        
        cancellable = client.location().getLocationsByPageNumber(pageNumber: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { locations in
                locations.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByPageNumberError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for page")
        
        cancellable = client.location().getLocationsByPageNumber(pageNumber: 123)
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
    
    func testRequestLocationsByIDs() {
        
        let expectation = XCTestExpectation(description: "Request multiple locations by ids")
        
        cancellable = client.location().getLocationsByID(ids: [1,2,3])
            .sink(receiveCompletion: { _ in }, receiveValue: { locations in
                locations.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestLocationsByIDsError() {
        
        let expectation = XCTestExpectation(description: "Request multiple locations by ids")
        
        cancellable = client.location().getLocationsByID(ids: [-1])
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
    
    func testRequestAllLocations() {
        
        let expectation = XCTestExpectation(description: "Request all locations")
        
        cancellable = client.location().getAllLocations()
            .sink(receiveCompletion: { _ in }, receiveValue: { locations in
                locations.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterLocations() {
        
        let expectation = XCTestExpectation(description: "Request locations by filter parameter")
        
        let filter = client.location().createLocationFilter(name: "earth", type: nil, dimension: nil)
        
        cancellable = client.location().getLocationsByFilter(filter: filter)
            .sink(receiveCompletion: { _ in }, receiveValue: { locations in
                locations.forEach() { print ($0.name) }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestFilterLocationsError() {
        
        let expectation = XCTestExpectation(description: "Test error handling for filter")
        
        let filter = client.location().createLocationFilter(name: "Test", type: "Test", dimension: "Test")
        
        cancellable = client.location().getLocationsByFilter(filter: filter)
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
        ("testRequestLocationByID", testRequestLocationByID),
        ("testRequestLocationByIDError", testRequestLocationByIDError),
        ("testRequestLocationByURL", testRequestLocationByURL),
        ("testRequestLocationByURLError", testRequestLocationByURLError),
        ("testRequestLocationsByIDs", testRequestLocationsByIDs),
        ("testRequestLocationsByIDs", testRequestLocationsByIDsError),
        ("testRequestLocationsByPageNumber", testRequestLocationsByPageNumber),
        ("testRequestLocationsByPageNumberError", testRequestLocationsByPageNumberError),
        ("testRequestAllLocations", testRequestAllLocations),
        ("testRequestFilterLocations", testRequestFilterLocations),
        ("testRequestFilterLocationsError", testRequestFilterLocationsError),
    ]
}
