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
      state = .data(
        try await client.getSets().data.map { set in
          State.Preview.Set(
            title: set.name,
            numberOfItems: set.cardCount,
            setID: set.code,
            iconURI: set.iconSvgUri
          )
        }
      )
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
    }
  }
}
