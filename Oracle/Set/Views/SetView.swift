import ComposableArchitecture
import SwiftUI
import ScryfallKit

struct SetView: View {
  let store: StoreOf<SetFeature>
  
  var body: some View {
    List(store.sets) { set in
      Text(set.name)
    }.onAppear(perform: {
      store.send(.viewAppeared)
    })
  }
}
