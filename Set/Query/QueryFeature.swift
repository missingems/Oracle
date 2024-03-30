import ComposableArchitecture
import ScryfallKit

@Reducer
struct QueryFeature {
  let client = ScryfallClient()
  
  @ObservableState
  struct State {
    let selectedSet: MTGSet
    var cards: [Card] = []
    
    var title: String {
      selectedSet.name
    }
    
    var subtitle: String {
      String(localized: "\(selectedSet.cardCount) Cards")
    }
  }
  
  enum Action {
    case viewAppeared
    case fetchCards(filter: [CardFieldFilter], page: Int)
    case didReceivedCards([Card])
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .fetchCards(filter, page):
        return .run { update in
          let result = try await client.searchCards(
            filters: filter,
            unique: nil,
            order: nil,
            sortDirection: nil,
            includeExtras: true,
            includeMultilingual: false,
            includeVariations: true,
            page: page
          ).data
          
          await update(.didReceivedCards(result))
        }
        
      case .viewAppeared:
        let code = state.selectedSet.code
        return .run { update in
          await update(
            .fetchCards(
              filter: [
                .set(code),
                .game(.paper)
              ],
              page: 1
            )
          )
        }
        
      case let .didReceivedCards(cards):
        state.cards = cards
        return .none
      }
    }
  }
}
