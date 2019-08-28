import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AnimationTests.allTests),
        testCase(TransitionTests.allTests)
    ]
}
#endif
