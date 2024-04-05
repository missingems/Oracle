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
                let card = store.displayingCards[index]
                
                NavigationLink(
                  state: Feature.Path.State.showCard(
                    CardFeature.State(
                      card: card,
                      cardSetImageURI: store.state.selectedSet.iconSvgUri
                    )
                  )
                ) {
                  AmbientWebImage(url: card.getImageURL(type: .normal))
                    .frame(height: ((proxy.size.width - 24.0) / 2 * 1.3928).rounded())
                    .redacted(reason: store.redactionReason)
                }
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
