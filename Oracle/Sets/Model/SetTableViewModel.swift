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
  private(set) var dataSource: [any GameSet] = []
  
  var didUpdate: StateHandler?
  
  init(client: any SetNetworkService) {
    self.client = client
  }
  
  func update(_ event: Event) {
    switch event {
    case .pullToRefreshInvoked:
      fetchSets { [weak self] in
        self?.didUpdate?(.shouldReloadData)
        self?.didUpdate?(.shouldEndRefreshing)
      }

    case .viewDidLoad:
      didUpdate?(.isLoading)
      
    case .viewWillAppear:
      fetchSets { [weak self] in
        self?.didUpdate?(.shouldReloadData)
      }
    }
  }
  
  private func fetchSets(onComplete: (() -> Void)? = nil) {
    client.fetchSets(filterType: .all) { [weak self] result in
      switch result {
      case let .success(value):
        self?.dataSource = value
        onComplete?()
        
      case let .failure(value):
        self?.didUpdate?(.shouldDisplayError(value))
      }
    }
  }
}

extension SetTableViewModel {
  enum Event: Equatable {
    case pullToRefreshInvoked
    case viewDidLoad
    case viewWillAppear
  }
  
  enum Message: Equatable {
    case shouldDisplayError(Error)
    case shouldEndRefreshing
    case shouldReloadData
    case isLoading
    
    static func == (lhs: SetTableViewModel.Message, rhs: SetTableViewModel.Message) -> Bool {
      switch (lhs, rhs) {
      case let (.shouldDisplayError(lhsValue), .shouldDisplayError(rhsValue)):
        return lhsValue.localizedDescription == rhsValue.localizedDescription
        
      case (.shouldEndRefreshing, .shouldEndRefreshing):
        return true
        
      case (.shouldReloadData, .shouldReloadData):
        return true
        
      case (.isLoading, .isLoading):
        return true
        
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
