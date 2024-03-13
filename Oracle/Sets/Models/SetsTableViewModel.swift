//
//  SetsTableViewModel.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import Foundation

final class SetsTableViewModel {
  typealias StateHandler = ((Message) -> ())
  
  private let client: any SetsTableViewNetworkService
  private(set) var dataSource: [any CardSet] {
    didSet {
      didUpdate?(.shouldReloadData)
    }
  }
  
  var didUpdate: StateHandler?
  let staticConfiguration: StaticConfiguration
  
  init(client: any SetsTableViewNetworkService) {
    self.client = client
    staticConfiguration = StaticConfiguration()
    dataSource = []
  }
  
  func fetchSets() {
    client.fetchSets { [weak self] result in
      guard let self else {
        return
      }
      
      switch result {
      case let .success(value):
        self.dataSource = value
        
      case .failure:
        self.didUpdate?(.isLoading)
      }
    }
  }
}

extension SetsTableViewModel {
  enum Message: Equatable {
    case shouldReloadData
    case isLoading
  }
}

extension SetsTableViewModel {
  struct StaticConfiguration: Equatable {
    let title = String(localized: "SetsTableViewControllerTitle")
    let tabBarSelectedSystemImageName = "book.pages.fill"
    let tabBarDeselectedSystemImageName = "book.pages"
  }
}
