import SwiftUI
import ComposableArchitecture

struct SetViewModel {
  @Bindable 
  var store: StoreOf<Feature>
  
  let title = String(localized: "Sets")
  let tabItemImageName = "list.bullet.rectangle.portrait"
  
  init(store: StoreOf<Feature>) {
    self.store = store
  }
  
  var redactionReason: RedactionReasons {
    store.loadingState == .isLoading ? .placeholder : .invalidated
  }
}
