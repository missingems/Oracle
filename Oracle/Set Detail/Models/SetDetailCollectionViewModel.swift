import ScryfallKit

struct SetDetailCollectionViewModel {
  private let client: ScryfallClient
  private(set) var state: State
  
  let title: String
  let set: MTGSet
  let subtitle: String
  
  init(set: MTGSet) {
    client = ScryfallClient(networkLogLevel: .minimal)
    state = .loading
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
      
      state = .data(cards: result.data)
    } catch {
      state = .error
    }
  }
}

extension SetDetailCollectionViewModel {
  enum State {
    case loading
    case data(cards: [Card])
    case error
    
    var cards: [Card] {
      if case let .data(value) = self {
        return value
      } else {
        return []
      }
    }
  }
}
