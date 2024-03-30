import ComposableArchitecture
import ScryfallKit

@Reducer
struct Feature {
  let fetchSets: () async throws -> [MTGSet]
  let fetchCards: (_ set: MTGSet, _ page: Int) async throws -> [Card]
  
  @Reducer
  struct Path {
    @ObservableState
    enum State {
      case selectSet(MTGSet)
    }
    
    enum Action {
      case selectSet(MTGSet)
    }
  }
  
  @ObservableState
  struct State {
    var cards: [Card] = []
    var mockSets = MTGSet.stubs
    var path = StackState<Path.State>()
    var sets: [MTGSet] = []    
  }
  
  enum Action {
    case didReceiveCards([Card], MTGSet)
    case didReceiveError
    case didReceiveSets([MTGSet])
    case fetchCards(MTGSet)
    case fetchSets
    case path(StackAction<Path.State, Path.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .didReceiveCards:
        return .none
        
      case .didReceiveError:
        fatalError()
        
      case let .didReceiveSets(result):
        return update(state: &state, with: .success(result))
        
      case let .fetchCards(set):
        return .run { update in
          await update(.didReceiveCards(try await fetchCards(set, 1), set))
        }
        
      case .fetchSets:
        return .run { update in
          do {
            await update(.didReceiveSets(try fetchSets()))
          } catch {
            await update(.didReceiveError)
          }
        }
        
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path) { Path() }
    ._printChanges(.actionLabels)
  }
}

// MARK: - Effects

extension Feature {  
  private func update(
    state: inout State,
    with result: Result<[MTGSet], Error>
  ) -> Effect<Action> {
    switch result {
    case let .success(response):
      state.sets = response
      
    case .failure:
      break
    }
    
    return .none
  }
}
