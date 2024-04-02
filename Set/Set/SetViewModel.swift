import ScryfallKit
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
    store.sets.isEmpty ? .placeholder : .invalidated
  }
  
  var isInteractivable: Bool {
    store.sets.isEmpty
  }
  
  var displayingSets: [MTGSet] {
    store.sets.isEmpty ? store.mockSets : store.sets
  }
  
  func navigationState(at index: Int) -> Feature.Path.State {
    .showQuery(.init(selectedSet: displayingSets[index]))
  }
  
  func makeSetListRowViewModel(for index: Int) -> SetListRowViewModel {
    SetListRowViewModel(
      set: displayingSets[index],
      index: index
    )
  }
}
