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
      
    case .searchBarResigned:
      resetDisplayingDatasource()
      didUpdate?(.shouldReloadData)
      
    case let .searchBarTextChanged(query):
      querySets(query: query) { [weak self] result in
        self?.updateDisplayingDataSource(with: result)
      }
      
    case .viewDidLoad, .pullToRefreshInvoked:
      fetchSets { [weak self] result in
        self?.updateDisplayingDataSource(with: result)
      }
    }
  }
  
  private func updateDisplayingDataSource(with result: Result<[Section], Error>) {
    DispatchQueue.main.async { [weak self] in
      switch result {
      case let .success(sections):
        self?.displayingDataSource = sections
        
      case let .failure(error):
        self?.displayingDataSource = []
        self?.didUpdate?(.shouldDisplayError(error))
      }
      
      self?.didUpdate?(.shouldReloadData)
      self?.didUpdate?(.shouldEndRefreshing)
    }
  }
  
  private func fetchSets(onComplete: ((Result<[Section], Error>) -> Void)? = nil) {
    didUpdate?(.isLoading)
    
    client.fetchSets { result in
      switch result {
      case let .success(value):
        onComplete?(.success([.sets(value)]))
        
      case let .failure(error):
        onComplete?(.failure(error))
      }
    }
  }
  
  private func querySets(query: String, onComplete: ((Result<[Section], Error>) -> Void)? = nil) {
    guard let client = coordinator?.makeNewServiceClient() else { return }
    self.client = client
    
    client.querySets(query: query, in: dataSource) { result in
      switch result {
      case let .success(sets):
        client.queryCards(query: query) { result in
          switch result {
          case let .success(cards):
            onComplete?(
              .success(
                [
                  .sets(sets),
                  .cards(cards)
                ].filter { $0.numberOfRows != 0 }
              )
            )
            
          case let .failure(error):
            onComplete?(.failure(error))
          }
        }
        
      case let .failure(error):
        onComplete?(.failure(error))
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
    let tabBarSelectedSystemImageName = "list.bullet.rectangle.portrait.fill"
    let tabBarDeselectedSystemImageName = "list.bullet.rectangle.portrait"
    let errorTitle = String(localized: "Oops, I missed a trigger...")
  }
}
