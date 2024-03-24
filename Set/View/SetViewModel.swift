import ComposableArchitecture

@Observable
final class SetViewModel {
  let store: StoreOf<Feature>
  
  init(store: StoreOf<Feature>) {
    self.store = store
    store.send(.fetchSets)
  }
}
