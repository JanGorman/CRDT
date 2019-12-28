//
//  Created by Jan Gorman on 26.12.19.
//

import XCTest
import CRDT

final class GSetTests: XCTestCase {

  func testLookup() {
    var set = GSet<String>()

    set.add("🐈")
    set.add("🐩")
    set.add("🐎")

    let lookup = set.lookup()

    XCTAssertEqual(lookup.count, 3)
    XCTAssertTrue(lookup.contains("🐈"))
    XCTAssertTrue(lookup.contains("🐩"))
    XCTAssertTrue(lookup.contains("🐎"))
    XCTAssertFalse(lookup.contains("🐒"))
  }

  func testMerge() {
    var first = GSet<String>()
    first.add("🐈")
    first.add("🐩")

    var second = GSet<String>()
    second.add("🐩")
    second.add("🐎")

    let merged = first.merge(with: second).lookup()

    XCTAssertEqual(merged.count, 3)
    XCTAssertTrue(merged.contains("🐈"))
    XCTAssertTrue(merged.contains("🐩"))
    XCTAssertTrue(merged.contains("🐎"))
  }

  func testDiff() {
    var first = GSet<String>()
    first.add("🐈")
    first.add("🐩")

    var second = GSet<String>()
    second.add("🐩")
    second.add("🐎")

    let diff = first.diff(second).lookup()

    XCTAssertEqual(diff.count, 1)
    XCTAssertTrue(diff.contains("🐈"))
  }

  static var allTests = [
    ("testLookup", testLookup),
    ("testMerge", testMerge),
    ("testDiff", testDiff)
  ]
}
