import Foundation
import ScryfallKit

final class SetTableViewModel {
  private var client: SetNetworkService
  let configuration: Configuration = Configuration()
  private weak var coordinator: SetCoordinator?
  private var dataSource: [MTGSet] = []
  private(set) var displayingDataSource: [Section] = []
  var didUpdate: ((Message) -> ())?
  private var isSearchActive = false
  
  init(client: SetNetworkService, coordinator: SetCoordinator) {
    self.client = client
    self.coordinator = coordinator
  }
  
  func update(_ event: Event) {
    switch event {
    case let .didSelectCardName(name):
      coordinator?.show(destination: .showCardResult(cardName: name))
      
    case let .didSelectSet(set):
      coordinator?.show(destination: .showSetDetail(set: set))
      
    case .searchBarResigned:
      isSearchActive = false
      displayingDataSource = [.sets(dataSource)]
      didUpdate?(.shouldDisplayData)
      
    case let .searchBarTextChanged(query):
      isSearchActive = true
      client = SetNetworkService()
      client.query(query, sets: dataSource) { [weak self] result in
        self?.updateDisplayingDataSource(with: result.map { response in
          [.sets(response.sets), .cards(response.cardNames)]
        })
      }
      
    case .viewDidLoad, .pullToRefreshValueChanged:
      fetchSets { [weak self] result in
        self?.updateDisplayingDataSource(with: result)
      }
    }
  }
  
  private func updateDisplayingDataSource(with result: Result<[Section], Error>) {
    DispatchQueue.main.async { [weak self] in
      switch result {
      case let .success(sections):
        self?.displayingDataSource = sections.filter { $0.numberOfRows != 0 }
        
      case let .failure(error):
        self?.displayingDataSource = []
        self?.didUpdate?(.shouldDisplayError(error))
      }
      
      self?.didUpdate?(.shouldDisplayData)
    }
  }
  
  private func fetchSets(onComplete: ((Result<[Section], Error>) -> Void)? = nil) {
    client.fetchSets { [weak self] result in
      switch result {
      case let .success(value):
        self?.dataSource = value
        onComplete?(.success([.sets(value)]))
        
      case let .failure(error):
        onComplete?(.failure(error))
      }
    }
  }
}

extension SetTableViewModel {
  enum Section {
    case sets([MTGSet])
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
    case didSelectCardName(String)
    case didSelectSet(MTGSet)
    case pullToRefreshValueChanged
    case searchBarResigned
    case searchBarTextChanged(String)
    case viewDidLoad
  }
  
  enum Message {
    case shouldDisplayError(Error)
    case shouldDisplayData
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
