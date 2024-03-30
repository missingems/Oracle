import ComposableArchitecture
import ScryfallKit

@Reducer
struct QueryFeature {
  @ObservableState
  struct State {
    let selectedSet: MTGSet
    private(set) var cards: [Card] = []
    
    var title: String {
      selectedSet.name
    }
    
    var subtitle: String {
      String(localized: "\(selectedSet.cardCount) Cards")
    }
  }
  
  enum Action {
    case viewAppeared
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .viewAppeared:
        return .none
      }
    }
    ._printChanges()
  }
}
