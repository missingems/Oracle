import ScryfallKit

struct SetDetailCollectionViewModel {
  private let client: ScryfallClient
  private(set) var state: State
  
  let title: String
  let set: MTGSet
  let subtitle: String
  
  init(set: MTGSet) {
    client = ScryfallClient(networkLogLevel: .minimal)
    state = .placeholder([Preview](repeating: .placeholder, count: set.cardCount))
    self.set = set
    title = set.name
    subtitle = String(localized: "\(set.cardCount) Cards")
  }
  
  mutating func fetchCards() async {
    do {
      let result = try await client.searchCards(
        filters: [.set(set.code)],
        unique: .prints,
        order: nil,
        sortDirection: .auto,
        includeExtras: true,
        includeMultilingual: false,
        includeVariations: true,
        page: nil
      )
      
      state = .data(result.data)
    } catch {
      state = .error
    }
  }
}

extension SetDetailCollectionViewModel {
  enum State {
    case loading
    case placeholder([Preview])
    case data([Card])
    case error
    
    var cards: [Card] {
      if case let .data(value) = self {
        return value
      }
      
      return []
    }
    
    var placeholders: [Preview] {
      if case let .placeholder(array) = self {
        return array
      }
      
      return []
    }
    
    var numberOfItems: Int {
      switch self {
      case let .data(cards):
        return cards.count
        
      case let .placeholder(value):
        return value.count
        
      default:
        return 0
      }
    }
  }
  
  enum Preview {
    case placeholder
  }
}
