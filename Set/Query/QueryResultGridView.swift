import ComposableArchitecture
import DesignComponent
import SwiftUI

extension QueryResultView {
  struct GridView: View {
    let store: StoreOf<QueryFeature>
    
    let columns: [GridItem] = [
      GridItem(.flexible(), spacing: 5),
      GridItem(.flexible(), spacing: 5),
    ]
    
    var body: some View {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 8) {
          ForEach(store.displayingCards.indices, id: \.self) { index in
            let card = store.displayingCards[index]
            
            NavigationLink(state: Feature.Path.State.showCard(CardFeature.State(card: card))) {
              AmbientWebImage(url: card.getImageURL(type: .normal), placeholderName: "mtgBack")
                .redacted(reason: store.redactionReason)
            }
            .onAppear { store.send(.loadMoreIfNeeded(index)) }
          }
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 13, trailing: 5))
      }
    }
  }
}
