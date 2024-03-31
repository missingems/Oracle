import ComposableArchitecture
import DesignComponent
import ScryfallKit
import SwiftUI
import SDWebImageSwiftUI

struct QueryResultView: View {
  @Bindable
  var store: StoreOf<QueryFeature>
  
  var body: some View {
    QueryResultView.GridView(store: store)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(store.title)
      .background {
        Color(.secondarySystemBackground).ignoresSafeArea()
      }
      .onAppear { store.send(.viewAppeared) }
  }
}

