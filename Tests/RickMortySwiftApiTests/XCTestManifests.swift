import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CharacterTests.allTests),
        testCase(EpisodeTests.allTests),
        testCase(LocationTests.allTests),
        testCase(NetworkHandlerTests.allTests),
    ]
}
#endif
