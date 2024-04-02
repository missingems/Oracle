import ComposableArchitecture
import SwiftUI

struct CardView: View {
  let store: StoreOf<CardFeature>
  
  var body: some View {
    Text(store.selectedCard.name).onAppear {
      store.send(.viewAppeared)
    }
  }
}
