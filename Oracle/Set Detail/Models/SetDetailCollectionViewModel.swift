import ScryfallKit

final class SetDetailCollectionViewModel {
  private let client: any SetDetailNetworkService
  private(set) var dataSource: [Card] = []
  let configuration: Configuration
  private let set: any GameSet
  var didUpdate: ((Message) -> ())?
  
  init(
    set: any GameSet,
    client: any SetDetailNetworkService
  ) {
    self.set = set
    self.client = client
    configuration = Configuration(set: set)
  }
  
  func update(_ event: Event) {
    switch event {
    case .viewDidLoad:
      fetchCards()
    }
  }
  
  private func fetchCards() {
    client.fetchSetDetail(gameSet: set, page: 0, sort: .released) { [weak self] result in
      switch result {
      case let .success(value):
        self?.dataSource = value
        self?.didUpdate?(.shouldReloadData)
        
      case let .failure(error):
        print(error)
        break
      }
    }
  }
}

extension SetDetailCollectionViewModel {
  enum Event {
    case viewDidLoad
  }
  
  enum Message {
    case shouldReloadData
  }
}

extension SetDetailCollectionViewModel {
  struct Configuration: Equatable {
    let subtitle: String
    let title: String
    
    init(set: any GameSet) {
      title = set.name
      subtitle = String(localized: "\(set.numberOfCards) Cards")
    }
  }
}
