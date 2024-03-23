import ComposableArchitecture
import Foundation
import ScryfallKit

@Reducer
struct Feature {
  let setsFetcher: () async throws -> ObjectList<MTGSet>
  
  @ObservableState
  struct State: Equatable {
    var sets: [MTGSet] = []
  }
  
  enum Action {
    case viewAppeared
    case setsResponse(ObjectList<MTGSet>)
    case setsError(Error)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppeared:
        return .run { send in
          do {
            await send(.setsResponse(try setsFetcher()))
          } catch {
            await send(.setsError(error))
          }
        }
        
      case .setsError:
        fatalError("Error handler not implemented")
        
      case let .setsResponse(result):
        state.sets = result.data
        return .none
      }
    }
  }
}
