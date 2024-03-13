//
//  SetsTableViewModel.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import Foundation

final class SetTableViewModel {
  typealias StateHandler = ((Message) -> ())
  
  private let client: any SetNetworkService
  let configuration: Configuration = Configuration()
  
  private(set) var dataSource: [any CardSet] = [] {
    didSet {
      didUpdate?(.shouldReloadData)
    }
  }
  
  var didUpdate: StateHandler?
  
  init(client: any SetNetworkService) {
    self.client = client
  }
  
  func update(_ event: Event) {
    switch event {
    case .viewDidLoad:
      didUpdate?(.isLoading)
      
    case .viewWillAppear:
      fetchSets()
    }
  }
  
  private func fetchSets() {
    client.fetchSets { [weak self] result in
      switch result {
      case let .success(value):
        self?.dataSource = value
        
      case let .failure(value):
        self?.didUpdate?(.shouldDisplayError(value))
      }
    }
  }
}

extension SetTableViewModel {
  enum Event: Equatable {
    case viewDidLoad
    case viewWillAppear
  }
  
  enum Message: Equatable {
    case shouldReloadData
    case isLoading
    case shouldDisplayError(Error)
    
    static func == (lhs: SetTableViewModel.Message, rhs: SetTableViewModel.Message) -> Bool {
      switch (lhs, rhs) {
      case (.shouldReloadData, .shouldReloadData):
        return true
        
      case (.isLoading, .isLoading):
        return true
        
      case let (.shouldDisplayError(lhsValue), .shouldDisplayError(rhsValue)):
        return lhsValue.localizedDescription == rhsValue.localizedDescription
        
      default:
        return false
      }
    }
  }
}

extension SetTableViewModel {
  struct Configuration: Equatable {
    let title = String(localized: "SetsTableViewControllerTitle")
    let tabBarSelectedSystemImageName = "book.pages.fill"
    let tabBarDeselectedSystemImageName = "book.pages"
  }
}
