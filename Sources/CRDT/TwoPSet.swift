//
//  Created by Jan Gorman on 26.12.19.
//

import Foundation

/// 2P-Set: Two-Phase-Set
public struct TwoPSet<T: Hashable>: Equatable {

  private(set) var addSet: GSet<T>
  private(set) var removeSet: GSet<T>

  public init() {
    addSet = GSet()
    removeSet = GSet()
  }

  public init(addSet: GSet<T>, removeSet: GSet<T>) {
    self.addSet = GSet(addSet.lookup())
    self.removeSet = GSet(removeSet.lookup())
  }

  public mutating func add(_ element: T) {
    addSet.add(element)
  }

  public mutating func remove(_ element: T) {
    removeSet.add(element)
  }

  public func merge(with other: TwoPSet<T>) -> TwoPSet<T> {
    TwoPSet(addSet: addSet.merge(with: other.addSet), removeSet: removeSet.merge(with: other.removeSet))
  }

  public func diff(_ other: TwoPSet<T>) -> TwoPSet<T> {
    TwoPSet(addSet: addSet.diff(other.addSet), removeSet: removeSet.diff(other.removeSet))
  }

  public func lookup() -> Set<T> {
    let result = addSet.diff(removeSet)
    return result.lookup()
  }

}
