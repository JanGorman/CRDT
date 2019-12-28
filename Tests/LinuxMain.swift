import XCTest

import CRDTTests

var tests = [XCTestCaseEntry]()
tests += GSetTests.allTests()
tests += LWWSetTests.allTests()
tests += ORSetTests.allTests()
tests += TwoPSetTests.allTests()
XCTMain(tests)
