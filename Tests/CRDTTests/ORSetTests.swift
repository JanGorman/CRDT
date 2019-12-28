//
//  Created by Jan Gorman on 26.12.19.
//

import XCTest
@testable import CRDT

final class ORSetTests: XCTestCase {

  func testLookup() {
    var set = ORSet<String>()

    set.add(.init(tag: "a", element: "🐩"))
    set.add(.init(tag: "b", element: "🐈"))
    set.add(.init(tag: "c", element: "🐒"))
    set.add(.init(tag: "c", element: "🐅"))

    set.remove(.init(tag: "a", element: "🐩"))
    set.remove(.init(tag: "b", element: "🐈"))

    let lookup = set.lookup()
    XCTAssertEqual(lookup.count, 2)
    XCTAssertTrue(lookup.contains("🐅"))
    XCTAssertTrue(lookup.contains("🐒"))
  }

  func testMerge() {
    var first = ORSet<String>()
    first.add(.init(tag: "b", element: "🐒"))
    first.add(.init(tag: "c", element: "🐩"))
    first.add(.init(tag: "d", element: "🐈"))
    first.remove(.init(tag: "d", element: "🐈"))

    var second = ORSet<String>()
    second.add(.init(tag: "a", element: "🐒"))
    second.add(.init(tag: "h", element: "🐅"))
    second.add(.init(tag: "d", element: "🐈"))
    second.remove(.init(tag: "a", element: "🐒"))

    let merged = first.merge(with: second)

    let mergedAddSet = merged.addSet.lookup()
    XCTAssertEqual(mergedAddSet.count, 5)
    XCTAssertTrue(mergedAddSet.contains(.init(tag: "a", element: "🐒")))
    XCTAssertTrue(mergedAddSet.contains(.init(tag: "b", element: "🐒")))
    XCTAssertTrue(mergedAddSet.contains(.init(tag: "c", element: "🐩")))
    XCTAssertTrue(mergedAddSet.contains(.init(tag: "d", element: "🐈")))
    XCTAssertTrue(mergedAddSet.contains(.init(tag: "h", element: "🐅")))

    let mergedRemoveSet = merged.removeSet.lookup()
    XCTAssertEqual(mergedRemoveSet.count, 2)
    XCTAssertTrue(mergedRemoveSet.contains(.init(tag: "d", element: "🐈")))
    XCTAssertTrue(mergedRemoveSet.contains(.init(tag: "a", element: "🐒")))

    let reverse = second.merge(with: first)
    XCTAssertEqual(reverse, merged)
  }

  func testDiff() {
    var first = ORSet<String>()
    first.add(.init(tag: "b", element: "🐒"))
    first.add(.init(tag: "c", element: "🐩"))
    first.add(.init(tag: "d", element: "🐈"))
    first.remove(.init(tag: "d", element: "🐈"))

    var second = ORSet<String>()
    second.add(.init(tag: "a", element: "🐒"))
    second.add(.init(tag: "h", element: "🐅"))
    second.add(.init(tag: "d", element: "🐈"))
    second.remove(.init(tag: "a", element: "🐒"))

    let diff = first.diff(second)

    let diffAddSet = diff.addSet.lookup()
    XCTAssertEqual(diffAddSet.count, 2)
    XCTAssertTrue(diffAddSet.contains(.init(tag: "b", element: "🐒")))
    XCTAssertTrue(diffAddSet.contains(.init(tag: "c", element: "🐩")))

    let diffRemoveSet = diff.removeSet.lookup()
    XCTAssertEqual(diffRemoveSet.count, 1)
    XCTAssertTrue(diffRemoveSet.contains(.init(tag: "d", element: "🐈")))
  }

  static var allTests = [
    ("testLookup", testLookup),
    ("testMerge", testMerge),
    ("testDiff", testDiff)
  ]

}
