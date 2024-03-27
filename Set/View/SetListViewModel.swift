import ComposableArchitecture

@Observable
final class SetListViewModel {
  let store: StoreOf<Feature>
  
  init(store: StoreOf<Feature>) {
    self.store = store
    store.send(.fetchSets)
  }
}
