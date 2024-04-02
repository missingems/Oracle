import ComposableArchitecture
import SwiftUI

struct CardView: View {
  let store: StoreOf<CardFeature>
  
  var body: some View {
    Text("").onAppear {
      store.send(.viewAppeared)
    }
  }
}
