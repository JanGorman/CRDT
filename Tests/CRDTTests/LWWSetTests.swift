//
//  Created by Jan Gorman on 26.12.19.
//

import XCTest
@testable import CRDT

final class LWWSetTests: XCTestCase {

  func testLookup() {
    var set = LWWSet<String>()

    set.add(.init(timestamp: 1, element: "🐩"))
    set.add(.init(timestamp: 1, element: "🐈"))
    set.add(.init(timestamp: 1, element: "🐒"))
    set.add(.init(timestamp: 1, element: "🐅"))

    set.remove(.init(timestamp: 2, element: "🐈"))
    set.remove(.init(timestamp: 2, element: "🐩"))

    let lookup = set.lookup()

    XCTAssertEqual(lookup.count, 2)
    XCTAssertTrue(lookup.contains("🐒"))
    XCTAssertTrue(lookup.contains("🐅"))
  }

  func testMerge() {
    var first = LWWSet<String>()
    first.add(.init(timestamp: 3, element: "🐒"))
    first.add(.init(timestamp: 1, element: "🐩"))
    first.add(.init(timestamp: 1, element: "🐈"))
    first.remove(.init(timestamp: 2, element: "🐈"))

    var second = LWWSet<String>()
    second.add(.init(timestamp: 1, element: "🐒"))
    second.add(.init(timestamp: 1, element: "🐅"))
    second.add(.init(timestamp: 1, element: "🐈"))
    second.remove(.init(timestamp: 2, element: "🐒"))

    let merged = first.merge(with: second)

    let mergedAddSet = merged.addSet.lookup()
    XCTAssertEqual(mergedAddSet.count, 5)
    XCTAssertTrue(mergedAddSet.contains(.init(timestamp: 1, element: "🐒")))
    XCTAssertTrue(mergedAddSet.contains(.init(timestamp: 3, element: "🐒")))
    XCTAssertTrue(mergedAddSet.contains(.init(timestamp: 1, element: "🐩")))
    XCTAssertTrue(mergedAddSet.contains(.init(timestamp: 1, element: "🐅")))
    XCTAssertTrue(mergedAddSet.contains(.init(timestamp: 1, element: "🐈")))

    let mergedRemoveSet = merged.removeSet.lookup()
    XCTAssertEqual(mergedRemoveSet.count, 2)
    XCTAssertTrue(mergedRemoveSet.contains(.init(timestamp: 2, element: "🐈")))
    XCTAssertTrue(mergedRemoveSet.contains(.init(timestamp: 2, element: "🐒")))
  }

  func testDiff() {
    var first = LWWSet<String>()
    first.add(.init(timestamp: 3, element: "🐒"))
    first.add(.init(timestamp: 1, element: "🐩"))
    first.add(.init(timestamp: 2, element: "🐅"))
    first.add(.init(timestamp: 1, element: "🐈"))
    first.remove(.init(timestamp: 2, element: "🐈"))

    var second = LWWSet<String>()
    second.add(.init(timestamp: 1, element: "🐒"))
    second.add(.init(timestamp: 3, element: "🐅"))
    second.add(.init(timestamp: 1, element: "🐈"))
    second.remove(.init(timestamp: 2, element: "🐒"))

    let diff = first.diff(second)

    let diffAddSet = diff.addSet.lookup()
    XCTAssertEqual(diffAddSet.count, 3)
    XCTAssertTrue(diffAddSet.contains(.init(timestamp: 3, element: "🐒")))
    XCTAssertTrue(diffAddSet.contains(.init(timestamp: 1, element: "🐩")))
    XCTAssertTrue(diffAddSet.contains(.init(timestamp: 2, element: "🐅")))

    let diffRemoveSet = diff.removeSet.lookup()
    XCTAssertEqual(diffRemoveSet.count, 1)
    XCTAssertTrue(diffRemoveSet.contains(.init(timestamp: 2, element: "🐈")))
  }

  static var allTests = [
    ("testLookup", testLookup),
    ("testMerge", testMerge),
    ("testDiff", testDiff)
  ]

}
