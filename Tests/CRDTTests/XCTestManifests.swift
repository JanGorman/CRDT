import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  [
    testCase(GSetTests.allTests),
    testCase(LWWSetTests.allTests),
    testCase(ORSetTests.allTests),
    testCase(TwoPSetTests.allTests)
  ]
}
#endif
