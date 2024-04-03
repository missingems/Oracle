import ComposableArchitecture
import DesignComponent
import SwiftUI

extension QueryResultView {
  struct ListView: View {
    let store: StoreOf<QueryFeature>
    
    var body: some View {
      ScrollView(.vertical) {
        LazyVGrid(columns: [GridItem(spacing: 0, alignment: .leading)], spacing: 0) {
          ForEach(store.displayingCards.indices, id: \.self) { index in
            let card = store.displayingCards[index]
            
            NavigationLink(state: Feature.Path.State.showCard(CardFeature.State(card: card, cardSetImageURI: store.selectedSet.iconSvgUri))) {
              VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 13.0) {
                  AmbientWebImage(url: card.getImageURL(type: .normal), placeholderName: "mtgBack")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 144, height: 144 * 1.3928, alignment: .leading)
                  
                  VStack(alignment: .leading, spacing: 5.0) {
                    HStack(alignment: .top) {
                      Text(card.name).font(.system(size: 15.0, weight: .semibold, design: .default)).padding(.trailing, 8).tint(.primary)
                      
                      if let manaCost = card.manaCost {
                        Spacer()
                        TokenizedTextView(manaCost, font: .systemFont(ofSize: 15.0), paragraphSpacing: 0).tint(.primary)
                      }
                    }
                    
                    if let typeline = card.typeLine {
                      Text(typeline).font(.system(size: 13.0, weight: .semibold, design: .default)).tint(.primary)
                    }
                    
                    if let text = card.oracleText {
                      TokenizedTextView(text, font: .systemFont(ofSize: 13.0), paragraphSpacing: 5.0).tint(.primary)
                    }
                    
                    if let flavorText = card.flavorText {
                      Text(flavorText).font(.system(size: 13, weight: .regular, design: .serif).italic()).tint(.secondary)
                    }
                    
                    if let power = card.power, let toughness = card.toughness {
                      Text("\(power)/\(toughness)")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                        .background {
                          Color(.systemFill)
                        }
                        .clipShape(.buttonBorder)
                        .padding(.top, 2.0)
                    }
                  }
                  .multilineTextAlignment(.leading)
                }
                .redacted(reason: store.state.redactionReason)
                .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                
                Divider().padding(.leading, 16.0)
              }
            }
            .onAppear { store.send(.loadMoreIfNeeded(index)) }
          }
        }
      }
    }
  }
}
