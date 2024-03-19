//
//  SetsTableViewModel.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import Foundation

final class SetTableViewModel {
  typealias StateHandler = ((Message) -> ())
  
  private var client: any SetNetworkService
  let configuration: Configuration = Configuration()
  private weak var coordinator: SetCoordinator?
  private var dataSource: [any GameSet] = []
  private(set) var displayingDataSource: [Section] = []
  
  var didUpdate: StateHandler?
  
  init(client: any SetNetworkService, coordinator: SetCoordinator) {
    self.client = client
    self.coordinator = coordinator
  }
  
  func update(_ event: Event) {
    switch event {
    case let .didSelectCard(name):
      coordinator?.show(destination: .showCardResult(cardName: name))
      
    case let .didSelectSet(set):
      coordinator?.show(destination: .showSetDetail(set: set))
      
    case .pullToRefreshInvoked:
      fetchSets { [weak self] (sections, dataSource) in
        self?.updateDisplayingDataSource(sections: sections, dataSource: dataSource)
      }
      
    case .searchBarResigned:
      resetDisplayingDatasource()
      didUpdate?(.shouldReloadData)
      
    case let .searchBarTextChanged(query):
      querySets(query: query) { [weak self] sections in
        self?.updateDisplayingDataSource(sections: sections, dataSource: self?.dataSource ?? [])
      }
      
    case .viewDidLoad:
      didUpdate?(.isLoading)
      fetchSets { [weak self] (sections, dataSource) in
        self?.updateDisplayingDataSource(sections: sections, dataSource: dataSource)
      }
    }
  }
  
  private func updateDisplayingDataSource(sections: [Section], dataSource: [any GameSet]) {
    DispatchQueue.main.async { [weak self] in
      self?.dataSource = dataSource
      self?.displayingDataSource = sections
      self?.didUpdate?(.shouldReloadData)
      self?.didUpdate?(.shouldEndRefreshing)
    }
  }
  
  private func fetchSets(onComplete: (((sections: [Section], dataSource: [any GameSet])) -> Void)? = nil) {
    didUpdate?(.isLoading)
    
    client.fetchSets { result in
      switch result {
      case let .success(value):
        onComplete?((sections: [.sets(value)], dataSource: value))
        
      case .failure:
        onComplete?((sections: [], dataSource: []))
      }
    }
  }
  
  private func querySets(query: String, onComplete: (([Section]) -> Void)? = nil) {
    guard let client = coordinator?.makeNewServiceClient() else { return }
    self.client = client
    
    client.querySets(query: query, in: dataSource) { result in
      switch result {
      case let .success(sets):
        client.queryCards(query: query) { result in
          switch result {
          case let .success(cards):
            onComplete?([.sets(sets), .cards(cards)].filter { $0.numberOfRows != 0 })
            
          case .failure:
            onComplete?([])
          }
        }
        
      case .failure:
        onComplete?([])
      }
    }
  }
  
  private func resetDisplayingDatasource() {
    displayingDataSource = [.sets(dataSource)]
  }
}

extension SetTableViewModel {
  enum Section {
    case sets([any GameSet])
    case cards([String])
    
    var numberOfRows: Int {
      switch self {
      case let .sets(items):
        return items.count
        
      case let .cards(items):
        return items.count
      }
    }
    
    var title: String {
      switch self {
      case .cards:
        return String(localized: "Cards").uppercased()
        
      case .sets:
        return String(localized: "Sets").uppercased()
      }
    }
  }
  
  enum Event {
    case didSelectCard(name: String)
    case didSelectSet(any GameSet)
    case pullToRefreshInvoked
    case searchBarResigned
    case searchBarTextChanged(String)
    case viewDidLoad
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
