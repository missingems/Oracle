import ComposableArchitecture

@Observable
final class SetListViewModel {
  let store: StoreOf<Feature>
  let title = String(localized: "Sets")
  
  init(store: StoreOf<Feature>) {
    self.store = store
    store.send(.fetchSets)
  }
}
