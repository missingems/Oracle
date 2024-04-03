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
              LazyVStack {
                AmbientWebImage(url: card.getImageURL(type: .normal), placeholderName: "mtgBack")
                  .frame(width: 184.5, height: 257.09)
                  .redacted(reason: store.redactionReason)
              }
            }
            .onAppear { store.send(.loadMoreIfNeeded(index)) }
          }
        }
        .padding(EdgeInsets(top: 5, leading: 8, bottom: 13, trailing: 8))
      }
    }
  }
}
