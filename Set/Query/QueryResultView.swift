import ComposableArchitecture
import DesignComponent
import ScryfallKit
import SwiftUI
import SDWebImageSwiftUI

struct QueryResultView: View {
  @Bindable
  var store: StoreOf<QueryFeature>
  
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        if store.viewState == .grid {
          QueryResultView.GridView(store: store, proxy: proxy)
        } else {
          QueryResultView.ListView(store: store)
        }
      }
      .animation(.easeInOut(duration: 0.2), value: store.viewState)
      .toolbar {
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
        
        ToolbarItem(placement: .principal) {
          VStack(spacing: 0) {
            Text(store.title).font(.headline).multilineTextAlignment(.center)
            Text(store.subtitle).font(.caption).fontWeight(.semibold).foregroundStyle(.secondary).multilineTextAlignment(.center)
          }
        }
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .background { Color(.secondarySystemBackground).ignoresSafeArea() }
    .onAppear { store.send(.viewAppeared) }
  }
}
