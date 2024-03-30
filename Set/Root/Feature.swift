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
      case showQuery(QueryFeature.State)
    }
    
    enum Action {
      case showQuery(QueryFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
      Scope(state: \.showQuery, action: \.showQuery) {
        QueryFeature()
      }
    }
  }
  
  @ObservableState
  struct State {
    var mockSets = MTGSet.stubs
    var path = StackState<Path.State>()
    var sets: [MTGSet] = []
  }
  
  enum Action {
    case didReceiveError
    case didReceiveSets([MTGSet])
    case fetchSets
    case path(StackAction<Path.State, Path.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .didReceiveError:
        fatalError()
        
      case let .didReceiveSets(result):
        state.sets = result
        return .none
        
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
    ._printChanges()
  }
}
