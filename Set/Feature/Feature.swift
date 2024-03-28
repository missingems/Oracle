import ComposableArchitecture
import ScryfallKit

@Reducer
struct Feature {
  let fetchSets: () async throws -> [MTGSet]
  let fetchCards: (_ set: MTGSet, _ page: Int) async throws -> [Card]
  
  @Reducer
  struct Path {
    @ObservableState
    enum State: Equatable {
      case selectSet
    }
    
    enum Action: Equatable {
      case selectSet
    }
    
    var body: some ReducerOf<Self> {
      Scope(state: \.selectSet, action: \.selectSet) {
//        AddFeature()
      }
    }
  }
  
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var loadingState: LoadingState = .isLoading
  }
  
  enum Action: Equatable {
    case didReceiveCards([Card], MTGSet)
    case didReceiveError
    case didReceiveSets([MTGSet])
    case didSelectSet(MTGSet)
    case fetchCards(MTGSet)
    case fetchSets
    case path(StackAction<Path.State, Path.Action>)
  }
  
  enum LoadingState: Equatable {
    case isLoaded([MTGSet])
    case isLoading
    
    var data: [MTGSet] {
      switch self {
      case let .isLoaded(sets):
        return sets
        
      case .isLoading:
        return MTGSet.stubs
      }
    }
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
            await update(.didReceiveError)
          }
        }
        
      case .path(.element(_, action: .selectSet)):
        state.path.append(.selectSet)
        return .none
        
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
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
      state.loadingState = .isLoaded(response)
      
    case .failure:
      break
    }
    
    return .none
  }
}
