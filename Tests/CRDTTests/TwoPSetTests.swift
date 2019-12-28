//
//  Created by Jan Gorman on 26.12.19.
//

import XCTest
@testable import CRDT

final class TwoPSetTests: XCTestCase {

  func testLookup() {
    var set = TwoPSet<String>()

    set.add("🐈")
    set.add("🐩")
    set.add("🐎")

    set.remove("🐈")
    set.remove("🐩")
    set.remove("🐒")

    let lookup = set.lookup()

    XCTAssertEqual(lookup.count, 1)
    XCTAssertTrue(lookup.contains("🐎"))
  }

  func testMerge() {
    var first = TwoPSet<String>()
    first.add("🐒")
    first.add("🐩")
    first.add("🐈")
    first.remove("🐈")

    var second = TwoPSet<String>()
    second.add("🐒")
    second.add("🐅")
    second.add("🐈")
    second.remove("🐒")

    let merged = first.merge(with: second)

    let mergedAddSet = merged.addSet.lookup()
    XCTAssertEqual(mergedAddSet.count, 4)
    XCTAssertTrue(mergedAddSet.contains("🐒"))
    XCTAssertTrue(mergedAddSet.contains("🐩"))
    XCTAssertTrue(mergedAddSet.contains("🐈"))
    XCTAssertTrue(mergedAddSet.contains("🐅"))

    let mergedRemoveSet = merged.removeSet.lookup()
    XCTAssertEqual(mergedRemoveSet.count, 2)
    XCTAssertTrue(mergedRemoveSet.contains("🐈"))
    XCTAssertTrue(mergedRemoveSet.contains("🐒"))

    let reverseMerge = second.merge(with: first)
    XCTAssertEqual(merged, reverseMerge)

    let selfMerge = first.merge(with: first)
    XCTAssertEqual(first, selfMerge)
  }

  func testDiff() {
    var first = TwoPSet<String>()
    first.add("🐒")
    first.add("🐩")
    first.add("🐈")
    first.remove("🐈")

    var second = TwoPSet<String>()
    second.add("🐒")
    second.add("🐅")
    second.add("🐈")
    second.remove("🐒")

    let diff = first.diff(second)

    let diffAddSet = diff.addSet.lookup()
    XCTAssertEqual(diffAddSet.count, 1)
    XCTAssertTrue(diffAddSet.contains("🐩"))

    let diffRemoveSet = diff.removeSet.lookup()
    XCTAssertEqual(diffRemoveSet.count, 1)
    XCTAssertTrue(diffRemoveSet.contains("🐈"))
  }

  static var allTests = [
    ("testLookup", testLookup),
    ("testMerge", testMerge),
    ("testDiff", testDiff)
  ]

}
