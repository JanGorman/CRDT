//
//  Created by Jan Gorman on 26.12.19.
//

import Foundation

/// LWW-Element-Set: Last-Write-Wins-Element-Set
public struct LWWSet<T: Hashable>: Equatable {

  public struct ElementState<T: Hashable>: Hashable {
    let timestamp: TimeInterval
    let element: T

    public init(timestamp: TimeInterval = Date().timeIntervalSince1970, element: T) {
      self.timestamp = timestamp
      self.element = element
    }
  }

  private(set) var addSet: GSet<ElementState<T>>
  private(set) var removeSet: GSet<ElementState<T>>

  public init() {
    addSet = GSet()
    removeSet = GSet()
  }

  init(addSet: GSet<ElementState<T>>, removeSet: GSet<ElementState<T>>) {
    self.addSet = addSet
    self.removeSet = removeSet
  }

  public mutating func add(_ element: ElementState<T>) {
    addSet.add(element)
  }

  public mutating func remove(_ element: ElementState<T>) {
    removeSet.add(element)
  }

  public func merge(with other: LWWSet<T>) -> LWWSet<T> {
    LWWSet(addSet: addSet.merge(with: other.addSet), removeSet: removeSet.merge(with: other.removeSet))
  }

  public func diff(_ other: LWWSet<T>) -> LWWSet<T> {
    let merged = merge(with: other)
    return LWWSet(addSet: merged.addSet.diff(other.addSet), removeSet: merged.removeSet.diff(other.removeSet))
  }

  public func lookup() -> Set<T> {
    Set(addSet.lookup().lazy.filter(nonRemoved).map { $0.element })
  }

  private func nonRemoved(_ addState: ElementState<T>) -> Bool {
    let lookup = removeSet.lookup()
    let removes = lookup.filter { el in
      el.element == addState.element && el.timestamp > addState.timestamp
    }
    return removes.isEmpty
  }

}
