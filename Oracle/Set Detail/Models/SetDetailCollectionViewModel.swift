import ScryfallKit

final class SetDetailCollectionViewModel {
  private let client: any SetDetailNetworkService
  private weak var coordinator: SetCoordinator?
  let configuration: Configuration
  private var currentPage: Int = 1
  private(set) var dataSource: [Card] = []
  var didUpdate: ((Message) -> ())?
  private var hasNext: Bool = false
  private var isLoading: Bool = false
  let query: QueryType
  private(set) var sortMode: SortMode = .released
  private(set) var sortDirection: SortDirection = .auto
  
  init(
    query: QueryType,
    client: any SetDetailNetworkService,
    coordinator: SetCoordinator
  ) {
    self.query = query
    self.client = client
    configuration = Configuration(query: query)
    self.coordinator = coordinator
  }
  
  func update(_ event: Event) {
    switch event {
    case let .didSelectCard(card):
      switch query {
      case let .set(gameSet):
        coordinator?.show(destination: .showCard(card, set: gameSet))
      case .card:
        coordinator?.show(destination: .showCard(card, set: nil))
      }
      
    case let .didSelectSortDirection(value):
      didUpdate?(.shouldShowIsLoading)
      sortDirection = value
      reset()
      fetchCards()
      
    case let .didSelectSortMode(value):
      didUpdate?(.shouldShowIsLoading)
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
    
    let completion: (Result<(cards: [Card], hasNext: Bool), Error>) -> () = { [weak self] result in
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
    
    switch query {
    case let .set(value):
      client.fetchSetDetail(gameSet: value, page: currentPage, sort: sortMode, direction: sortDirection, completion: completion)
      
    case let .card(value):
      client.fetchCards(cardName: value, page: currentPage, sort: sortMode, direction: sortDirection, completion: completion)
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
  
  var selectedSortModeTitle: String {
    String(localized: "Sort by \(sortMode.description)")
  }
  
  var selectedSortDirectionTitle: String {
    String(localized: "Order by \(sortDirection.description)")
  }
}

extension SetDetailCollectionViewModel {
  enum QueryType {
    case set(MTGSet)
    case card(String)
    
    var title: String {
      switch self {
      case let .set(value):
        return value.name
        
      case let .card(value):
        return value
      }
    }
    
    var subtitle: String? {
      switch self {
      case let .set(value):
        return String(localized: "\(value.cardCount) Cards")
        
      case .card:
        return nil
      }
    }
  }
  
  enum Event {
    case didSelectCard(Card)
    case didSelectSortDirection(SortDirection)
    case didSelectSortMode(SortMode)
    case pullToRefresh
    case viewDidLoad
    case willDisplayItem(index: Int)
  }
  
  enum Message {
    case shouldReloadData
    case shouldShowIsLoading
  }
}

extension SetDetailCollectionViewModel {
  struct Configuration: Equatable {
    let subtitle: String?
    let title: String
    let availableSort: [SortMode]
    let availableSortDirection: [SortDirection]
    
    init(query: QueryType) {
      title = query.title
      subtitle = query.subtitle
      
      availableSort = [
        .released,
        .rarity,
        .usd,
        .set,
        .color,
        .cmc,
        .power,
        .toughness
      ]
      
      availableSortDirection = SortDirection.allCases
    }
  }
}

extension SortDirection {
  var description: String {
    switch self {
    case .asc:
      return String(localized: "Ascending")
    case .desc:
      return String(localized: "Descending")
    case .auto:
      return String(localized: "Automatic")
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
    case .cmc:
      return String(localized: "Mana Value")
    case .power:
      return String(localized: "Power")
    case .toughness:
      return String(localized: "Toughness")
    default:
      return ""
    }
  }
}
