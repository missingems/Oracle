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
  
  var isScrollEnabled: Bool {
    store.sets.isEmpty
  }
  
  var displayingSets: [MTGSet] {
    store.sets.isEmpty ? store.mockSets : store.sets
  }
  
  func navigationState(at index: Int) -> Feature.Path.State {
    return Feature.Path.State.selectSet(displayingSets[index])
  }
  
  func navigate(with store: StoreOf<Feature.Path>) -> some View {
    switch store.state {
    case let .selectSet(set):
      QueryResultView(
        viewModel: QueryResultViewModel(
          selectedSet: set,
          store: self.store
        )
      )
    }
  }
  
  func makeSetListRowViewModel(for index: Int) -> SetListRowViewModel {
    SetListRowViewModel(
      set: displayingSets[index],
      index: index
    )
  }
}
