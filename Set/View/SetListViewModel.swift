import SwiftUI
import ComposableArchitecture

struct SetListViewModel {
  @Bindable var store: StoreOf<Feature>
  let title = String(localized: "Sets")
  
  init(store: StoreOf<Feature>) {
    self.store = store
    store.send(.fetchSets)
  }
}
