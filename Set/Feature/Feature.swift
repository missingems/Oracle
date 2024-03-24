import ComposableArchitecture
import ScryfallKit

@Reducer
struct Feature {
  let fetchSets: () async throws -> [MTGSet]
  
  @ObservableState
  struct State: Equatable {
    var sets: [MTGSet]
    let title: String
    let tabItemImageName: String
    
    init() {
      self.sets = []
      self.title = String(localized: "Sets")
      self.tabItemImageName = "list.bullet.rectangle.portrait"
    }
  }
  
  enum Action {
    case fetchSets
    case didReceiveSets([MTGSet])
    case didReceiveError(Error)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchSets:
        return .run { update in
          do {
            await update(.didReceiveSets(try fetchSets()))
          } catch {
            await update(.didReceiveError(error))
          }
        }
        
      case let .didReceiveError(error):
        return update(state: &state, with: .failure(error))
        
      case let .didReceiveSets(result):
        return update(state: &state, with: .success(result))
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
