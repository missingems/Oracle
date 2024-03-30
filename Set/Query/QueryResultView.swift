import ComposableArchitecture
import ScryfallKit
import SwiftUI

struct QueryResultView: View {
  @Bindable
  var store: StoreOf<QueryFeature>
  
  var body: some View {
    List(store.cards) { card in
      Text(card.name)
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        VStack {
          Text(store.title)
            .font(.headline)
          
          Text(store.subtitle)
            .font(.caption)
        }
      }
    }
    .onAppear {
      store.send(.viewAppeared)
    }
  }
}
