import ComposableArchitecture
import DesignComponent
import ScryfallKit
import SwiftUI

struct QueryResultView: View {
  let store: StoreOf<QueryFeature>
  
  var body: some View {
    GeometryReader { proxy in
      if proxy.size.width > 0 {
        ScrollView {
          LazyVGrid(
            columns: [
              GridItem(.flexible(), spacing: 8),
              GridItem(.flexible(), spacing: 8)
            ],
            spacing: 8
          ) {
            ForEach(store.displayingCards.indices, id: \.self) { index in
              let imageURLs = store.state.displayingCards[index].imageURLs
              
              NavigationCardImageView(
                imageURLs: imageURLs,
                linkState: store.state.pathState(at: index),
                shouldShowTransformButton: store.state.shouldShowTransformButton(at: index),
                width: (proxy.size.width - 24.0) / 2
              ) {
                EmptyView()
              }
              .onAppear { store.send(.loadMoreIfNeeded(index)) }
            }
          }
          .padding(EdgeInsets(top: 5, leading: 8, bottom: 13, trailing: 8))
        }
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(store.title)
    .background { Color(.secondarySystemBackground).ignoresSafeArea() }
    .onAppear { store.send(.viewAppeared) }
  }
}
