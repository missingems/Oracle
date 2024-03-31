import ComposableArchitecture
import DesignComponent
import ScryfallKit
import SwiftUI
import SDWebImageSwiftUI

struct QueryResultView: View {
  @Bindable
  var store: StoreOf<QueryFeature>
  
  var body: some View {
    List(store.displayingCards) { card in
      HStack(alignment: .top, spacing: 8.0) {
        AmbientWebImage(url: card.getImageURL(type: .normal), placeholderName: "mtgBack")
          .aspectRatio(contentMode: .fit)
          .frame(width: 144, height: 144 * 1.3928, alignment: .leading)
        
        VStack(alignment: .leading, spacing: 5.0) {
          HStack(alignment: .top) {
            Text(card.name).font(.system(size: 15.0, weight: .bold, design: .default)).padding(.trailing, 8)
            
            if let manaCost = card.manaCost {
              Spacer()
              TokenizedTextView(manaCost, font: .systemFont(ofSize: 15.0))
            }
          }
          
          if let typeline = card.typeLine {
            Text(typeline).font(.system(size: 13.0, weight: .semibold, design: .default))
          }

          if let text = card.oracleText {
            TokenizedTextView(text, font: .systemFont(ofSize: 13.0))
          }
          
          if let flavorText = card.flavorText {
            Text(flavorText).font(.system(size: 13, weight: .regular, design: .serif).italic()).foregroundStyle(.secondary)
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
      }
      .redacted(reason: store.state.redactionReason)
      .listSectionSeparator(.hidden, edges: .top)
      .alignmentGuide(.listRowSeparatorLeading) { dimension in
        dimension[.leading]
      }
      .listRowInsets(EdgeInsets(top: 13, leading: 16, bottom: 13, trailing: 16))
      .listRowBackground(Color(uiColor: .systemBackground))
    }
    .listStyle(.plain)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        VStack(spacing: 0.0) {
          Text(store.title)
            .font(.headline)
          
          Text(store.subtitle)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
        }
      }
    }
    .onAppear {
      store.send(.viewAppeared)
    }
  }
}
