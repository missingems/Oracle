import ComposableArchitecture
import ScryfallKit

@Reducer
struct CardFeature {
  let client = ScryfallClient()
  
  @ObservableState
  struct State {
    let selectedCard: Card
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
  }
}
