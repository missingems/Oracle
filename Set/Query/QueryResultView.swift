import ComposableArchitecture
import DesignComponent
import ScryfallKit
import SwiftUI

struct QueryResultView: View {
  @Bindable
  var store: StoreOf<QueryFeature>
  
  var body: some View {
    content.toolbar {
      ToolbarItem(placement: .navigation) {
        Menu {
          Button("List", systemImage: "list.bullet") {
            store.send(.viewStateChanged(.list))
          }
          
          Button("Grid", systemImage: "square.grid.2x2.fill") {
            store.send(.viewStateChanged(.grid))
          }
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(store.title)
    .background { Color(.secondarySystemBackground).ignoresSafeArea() }
    .onAppear { store.send(.viewAppeared) }
  }
  
  
  @ViewBuilder
  private var content: some View {
    if store.viewState == .grid {
      QueryResultView.GridView(store: store)
    } else {
      QueryResultView.ListView(store: store)
    }
  }
}
