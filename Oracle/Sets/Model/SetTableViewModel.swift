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
  private weak var coordinator: SetCoordinator?
  private var dataSource: [any GameSet] = []
  private(set) var displayingDataSource: [any GameSet] = []
  
  var didUpdate: StateHandler?
  
  init(client: any SetNetworkService, coordinator: SetCoordinator) {
    self.client = client
    self.coordinator = coordinator
  }
  
  func update(_ event: Event) {
    switch event {
    case let .didSelectSet(set):
      coordinator?.show(destination: .showSetDetail(set: set))
      
    case .pullToRefreshInvoked:
      fetchSets { [weak self] in
        self?.didUpdate?(.shouldReloadData)
        self?.didUpdate?(.shouldEndRefreshing)
      }
      
    case .searchBarResigned:
      resetDisplayingDatasource()
      didUpdate?(.shouldReloadData)
      
    case let .searchBarTextChanged(query):
      querySets(query: query) { [weak self] in
        self?.didUpdate?(.shouldReloadData)
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
    client.fetchSets { [weak self] result in
      switch result {
      case let .success(value):
        self?.dataSource = value
        self?.displayingDataSource = value
        onComplete?()
        
      case let .failure(value):
        self?.didUpdate?(.shouldDisplayError(value))
        onComplete?()
      }
    }
  }
  
  private func querySets(query: String, onComplete: (() -> Void)? = nil) {
    client.querySets(query: query, in: dataSource) { [weak self] result in
      switch result {
      case let .success(value):
        self?.displayingDataSource = value
        onComplete?()
        
      case let .failure(value):
        self?.displayingDataSource = []
        onComplete?()
      }
    }
  }
  
  private func resetDisplayingDatasource() {
    displayingDataSource = dataSource
  }
}

extension SetTableViewModel {
  enum Event {
    case didSelectSet(any GameSet)
    case pullToRefreshInvoked
    case searchBarResigned
    case searchBarTextChanged(String)
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
    let searchBarPlaceholder = String(localized: "SetsTableViewControllerSearchBarPlaceholder")
    let title = String(localized: "SetsTableViewControllerTitle")
    let tabBarSelectedSystemImageName = "book.pages.fill"
    let tabBarDeselectedSystemImageName = "book.pages"
  }
}
