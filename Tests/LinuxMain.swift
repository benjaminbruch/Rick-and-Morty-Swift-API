import XCTest

import rick_morty_swift_apiTests

var tests = [XCTestCaseEntry]()
tests += CharacterTests.allTests()
tests += EpisodeTests.allTests()
tests += LocationTests.allTests()
tests += NetworkHandler.allTests()
XCTMain(tests)
