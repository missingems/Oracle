//
//  SetsTableViewModel.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import Foundation
import ScryfallKit

final class SetsTableViewModel {
  private(set) var state: State
  
  private let client: ScryfallClient
  
  init(state: State) {
    self.state = state
    client = ScryfallClient()
  }
  
  func fetchSets() async -> State {
    do {
      let data = try await client.getSets().data
      var sections: [[State.Preview.Set]] = data.filter { $0.parentSetCode == nil }.map { [State.Preview.Set($0) ]}
      
      for (index, section) in sections.enumerated() {
        sections[index] = section + data.filter {
          $0.parentSetCode == section.first?.setID && $0.cardCount != 0
        }.map(State.Preview.Set.init)
      }
      
      state = .data(sections.flatMap { $0 })
    } catch {
      state =  .loading
    }
    
    return state
  }
}

extension SetsTableViewModel {
  enum State: Equatable {
    case loading
    case data([Preview.Set])
    
    var sets: [Preview.Set] {
      if case let .data(value) = self {
        return value
      } else {
        return []
      }
    }
    
    var title: String {
      return String(localized: "SetsTableViewControllerTitle")
    }
  }
}

extension SetsTableViewModel.State {
  struct Preview: Equatable {
    struct Set: Equatable {
      let title: String
      let numberOfItems: Int
      let setID: String
      let iconURI: String
      let isParentSet: Bool
      
      init(_ set: MTGSet) {
        title = set.name
        numberOfItems = set.cardCount
        setID = set.code
        iconURI = set.iconSvgUri
        isParentSet = set.parentSetCode != nil
      }
    }
  }
}
