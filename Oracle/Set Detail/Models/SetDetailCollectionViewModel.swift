import ScryfallKit

final class SetDetailCollectionViewModel {
  private let client: any SetDetailNetworkService
  let configuration: Configuration
  private var currentPage: Int = 1
  private(set) var dataSource: [Card] = []
  var didUpdate: ((Message) -> ())?
  private var hasNext: Bool = false
  private var isLoading: Bool = false
  let set: any GameSet
  private(set) var sortMode: SortMode = .released
  
  
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
    case let .didSelectSortMode(value):
      sortMode = value
      reset()
      fetchCards()
      
    case .pullToRefresh:
      reset()
      fetchCards()
      
    case .viewDidLoad:
      fetchCards()
      
    case let .willDisplayItem(index):
      if shouldLoadNextPage(at: index) {
        fetchCards()
      }
    }
  }
  
  private func fetchCards() {
    guard isLoading == false else {
      return
    }
    
    isLoading = true
    
    client.fetchSetDetail(gameSet: set, page: currentPage, sort: sortMode) { [weak self] result in
      self?.isLoading = false
      
      switch result {
      case let .success(value):
        if self?.currentPage == 1 {
          self?.dataSource = value.cards
        } else {
          self?.dataSource.append(contentsOf: value.cards)
        }
        
        self?.hasNext = value.hasNext
        
        if value.hasNext {
          self?.currentPage += 1
        }
        
        self?.didUpdate?(.shouldReloadData)
        
      case let .failure(error):
        print(error)
        break
      }
    }
  }
  
  private func shouldLoadNextPage(at index: Int) -> Bool {
    if index == dataSource.count - 4, hasNext {
      return true
    } else {
      return false
    }
  }
  
  private func reset() {
    currentPage = 1
    isLoading = false
  }
}

extension SetDetailCollectionViewModel {
  enum Event {
    case didSelectSortMode(SortMode)
    case pullToRefresh
    case viewDidLoad
    case willDisplayItem(index: Int)
  }
  
  enum Message {
    case shouldReloadData
  }
}

extension SetDetailCollectionViewModel {
  struct Configuration: Equatable {
    let subtitle: String
    let title: String
    let availableSort: [SortMode]
    
    init(set: any GameSet) {
      title = set.name
      subtitle = String(localized: "\(set.numberOfCards) Cards")
      
      availableSort = [
        .released,
        .rarity,
        .usd,
        .color,
        .cmc,
        .power,
        .toughness
      ]
    }
  }
}

extension SortMode {
  var description: String {
    switch self {
    case .usd:
      return String(localized: "Price")
    case .name:
      return String(localized: "Name")
    case .set:
      return String(localized: "Number")
    case .released:
      return String(localized: "Latest")
    case .rarity:
      return String(localized: "Rarity")
    case .color:
      return String(localized: "Color")
    case .tix:
      return String(localized: "Tix")
    case .eur:
      return String(localized: "Eur")
    case .cmc:
      return String(localized: "Mana Value")
    case .power:
      return String(localized: "Power")
    case .toughness:
      return String(localized: "Toughness")
    case .edhrec:
      return String(localized: "EDHREC")
    case .artist:
      return String(localized: "Artist")
    }
  }
}
