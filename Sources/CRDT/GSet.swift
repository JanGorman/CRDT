//
//  Created by Jan Gorman on 26.12.19.
//

import Foundation

/// G-Set: Grow-only Set
public struct GSet<T: Hashable>: Equatable {

  private var set: Set<T>

  public init() {
    set = Set()
  }

  init(_ set: Set<T>) {
    self.set = set
  }

  public mutating func add(_ element: T) {
    set.insert(element)
  }

  public func merge(with other: GSet<T>) -> GSet<T> {
    let newSet = self.set.union(other.lookup())
    return GSet(newSet)
  }

  public func diff(_ other: GSet<T>) -> GSet<T> {
    let newSet = set.subtracting(other.lookup())
    return GSet(newSet)
  }

  public func lookup() -> Set<T> {
    set
  }

}
