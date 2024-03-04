//
//  SetsTableViewModel.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import Foundation
import ScryfallKit

struct SetsTableViewModel {
  private(set) var state: State
  
  private let client: ScryfallClient
  
  init(state: State) {
    self.state = state
    client = ScryfallClient()
  }
  
  mutating func fetchSets() async {
    do {
      let data = try await client.getSets().data
      var sections: [[MTGSet]] = data.filter { $0.parentSetCode == nil }.map { [$0]}
      
      for (index, section) in sections.enumerated() {
        sections[index] = section + data.filter {
          $0.parentSetCode == section.first?.code && $0.cardCount != 0
        }
      }
      
      state = .data(sections.flatMap { $0 })
    } catch {
    }
  }
}

extension SetsTableViewModel {
  enum State: Equatable {
    case loading
    case data([MTGSet])
    
    var sets: [MTGSet] {
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
