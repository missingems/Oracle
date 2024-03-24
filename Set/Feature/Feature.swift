import ComposableArchitecture
import ScryfallKit

@Reducer
struct Feature {
  let setsFetcher: () async throws -> ObjectList<MTGSet>
  
  @ObservableState
  struct State: Equatable {
    var sets: [MTGSet] = []
  }
  
  enum Action {
    case fetchSets
    case didReceiveSets(ObjectList<MTGSet>)
    case didReceiveError(Error)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchSets:
        return fetchSets()
        
      case .didReceiveError:
        fatalError("Error handler not implemented")
        
      case let .didReceiveSets(result):
        return update(state: &state, with: result)
      }
    }
  }
}

// MARK: - Effects

extension Feature {
  private func fetchSets() -> Effect<Action> {
    .run { update in
      do {
        await update(.didReceiveSets(try setsFetcher()))
      } catch {
        await update(.didReceiveError(error))
      }
    }
  }
  
  private func update(
    state: inout State,
    with result: ObjectList<MTGSet>
  ) -> Effect<Action> {
    state.sets = result.data
    return .none
  }
}
