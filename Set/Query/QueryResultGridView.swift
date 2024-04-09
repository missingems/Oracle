import ScryfallKit
import ComposableArchitecture
import DesignComponent
import SwiftUI

extension QueryResultView {
  struct GridView: View {
    let store: StoreOf<QueryFeature>
    
    let columns: [GridItem] = [
      GridItem(.flexible(), spacing: 8),
      GridItem(.flexible(), spacing: 8),
    ]
    
    var body: some View {
      GeometryReader { proxy in
        if proxy.size.width > 0 {
          ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
              ForEach(store.displayingCards.indices, id: \.self) { index in
                NavigationCardImageView(
                  images: store.state.images(at: index),
                  linkState: store.state.pathState(at: index),
                  shouldShowTransformButton: store.state.shouldShowTransformButton(at: index),
                  width: (proxy.size.width - 24.0) / 2, 
                  cycle: Cycle(max: store.state.images(at: index).count)
                )
                .onAppear { store.send(.loadMoreIfNeeded(index)) }
              }
            }
            .padding(EdgeInsets(top: 5, leading: 8, bottom: 13, trailing: 8))
          }
        }
      }
    }
  }
}
