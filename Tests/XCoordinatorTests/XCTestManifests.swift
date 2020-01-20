import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(AnimationTests.allTests),
        testCase(TransitionTests.allTests)
    ]
}
#endif
