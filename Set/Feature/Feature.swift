import ComposableArchitecture
import ScryfallKit

@Reducer
struct Feature {
  let fetchSets: () async throws -> [MTGSet]
  let fetchCards: (_ set: MTGSet, _ page: Int) async throws -> [Card]
  
  @Reducer(state: .equatable)
  enum Path {
    case queryResult([Card])
  }
  
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var sets: [MTGSet]
    
    init() {
      self.sets = []
    }
  }
  
  enum Action {
    case didReceiveCards([Card], MTGSet)
    case didReceiveError(Error)
    case didReceiveSets([MTGSet])
    case didSelectSet(MTGSet)
    case fetchCards(MTGSet)
    case fetchSets
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .didReceiveCards:
        return .none
        
      case let .didReceiveError(error):
        return update(state: &state, with: .failure(error))
        
      case let .didReceiveSets(result):
        return update(state: &state, with: .success(result))
        
      case let .didSelectSet(set):
        return .run { update in
          await update(.fetchCards(set))
        }
        
      case let .fetchCards(set):
        return .run { update in
          await update(.didReceiveCards(try await fetchCards(set, 1), set))
        }
        
      case .fetchSets:
        return .run { update in
          do {
            await update(.didReceiveSets(try fetchSets()))
          } catch {
            await update(.didReceiveError(error))
          }
        }
      }
    }
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
