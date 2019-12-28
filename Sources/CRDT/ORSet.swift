//
//  Created by Jan Gorman on 26.12.19.
//

import Foundation

/// OR-Set: Observed-Remove-Set
public struct ORSet<T: Hashable>: Equatable {

  public struct ElementState<T: Hashable>: Hashable {
    let tag: String
    let element: T

    public init(tag: String, element: T) {
      self.tag = tag
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

  public func merge(with other: ORSet<T>) -> ORSet<T> {
    ORSet(addSet: addSet.merge(with: other.addSet), removeSet: removeSet.merge(with: other.removeSet))
  }

  public func diff(_ other: ORSet<T>) -> ORSet<T> {
    ORSet(addSet: addSet.diff(other.addSet), removeSet: removeSet.diff(other.removeSet))
  }

  public func lookup() -> Set<T> {
    Set(addSet.lookup().lazy.filter{ !self.removeSet.lookup().contains($0) }.map { $0.element })
  }

}
