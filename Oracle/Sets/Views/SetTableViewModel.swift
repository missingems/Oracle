//
//  SetsTableViewModel.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import Foundation

final class SetTableViewModel {
  typealias StateHandler = ((Message) -> ())
  
  private let client: any SetTableViewNetworkService
  private(set) var dataSource: [any CardSet] {
    didSet {
      didUpdate?(.shouldReloadData)
    }
  }
  
  var didUpdate: StateHandler?
  let staticConfiguration: StaticConfiguration
  
  init(client: any SetTableViewNetworkService) {
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

extension SetTableViewModel {
  enum Message: Equatable {
    case shouldReloadData
    case isLoading
  }
}

extension SetTableViewModel {
  struct StaticConfiguration: Equatable {
    let title = String(localized: "SetsTableViewControllerTitle")
    let tabBarSelectedSystemImageName = "book.pages.fill"
    let tabBarDeselectedSystemImageName = "book.pages"
  }
}
