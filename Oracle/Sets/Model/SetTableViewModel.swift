import Foundation

final class SetTableViewModel {
  typealias StateHandler = ((Message) -> ())
  
  private var client: SetNetworkService
  let configuration: Configuration = Configuration()
  private weak var coordinator: SetCoordinator?
  private var dataSource: [any GameSet] = []
  private(set) var displayingDataSource: [Section] = []
  var didUpdate: StateHandler?
  
  init(client: SetNetworkService, coordinator: SetCoordinator) {
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
      client = SetNetworkService()
      client.query(query, sets: dataSource) { [weak self] result in
        self?.updateDisplayingDataSource(with: result.map { response in
          [.sets(response.sets), .cards(response.cardNames)]
        })
      }
      break
      
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
  
  enum Message {
    case shouldDisplayError(Error)
    case shouldEndRefreshing
    case shouldReloadData
    case shouldDisplayData
    case isLoading
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
