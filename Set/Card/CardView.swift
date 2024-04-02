import ComposableArchitecture
import DesignComponent
import SwiftUI

struct CardView: View {
  let store: StoreOf<CardFeature>
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 11) {
        AmbientWebImage(url: store.cardImageURL, placeholderName: "mtgBack", cornerRadius: 15.0).padding(EdgeInsets(top: 11, leading: 55, bottom: 11, trailing: 55))
        Divider().padding(.leading, 16.0)
        
        HStack(alignment: .center) {
          if let name = store.name {
            Text(name).font(.title2).bold().padding(.horizontal, 16.0)
          }
          
          Spacer()
          
          if let mana = store.manaCost {
            TokenizedTextView(mana, font: .preferredFont(forTextStyle: .body)).padding(.horizontal, 16.0)
          }
        }
        
        if let typeline = store.typeLine {
          Divider().padding(.leading, 16.0)
          Text(typeline).font(.body).padding(.horizontal, 16.0)
        }
        
        if let text = store.text {
          Divider().padding(.leading, 16.0)
          TokenizedTextView(text, font: .preferredFont(forTextStyle: .body)).padding(.horizontal, 16.0)
        }
        
        if let flavorText = store.flavorText {
          Divider().padding(.leading, 16.0)
          Text(flavorText).font(.body).fontDesign(.serif).italic().foregroundStyle(Color.secondary).padding(.horizontal, 16.0)
        }
        
        Divider().padding(.leading, 16.0)
        
        Text(store.legalityLabel).font(.headline).padding(.leading, 16.0)
        
        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 3.0) {
          ForEach(store.allLegalities.indices, id: \.self) { index in
            let legality = store.allLegalities[index]
            let value = store.card.legalities.type(legality)
            var counter = 0
            
            HStack {
              Text("\(value.1?.localisedDescription ?? "")")
                .foregroundStyle(Color.white)
                .frame(minWidth: 0, maxWidth: .infinity).font(.system(size: 12))
                .padding(.vertical, 5.0)
                .font(.system(size: 12, weight: .medium))
                .monospaced()
                .background {
                  if let color = value.1?.color {
                    Color(uiColor: color)
                  }
                }
                .clipShape(ButtonBorderShape.roundedRectangle)
              Text("\(value.0)")
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 12, weight: .regular))
                .multilineTextAlignment(.leading)
            }.background {
              Color.quaternarySystemFill.clipShape(ButtonBorderShape.roundedRectangle)
            }
          }
        }
        .padding(.horizontal, 16.0)
      }
    }
    .background { Color(.secondarySystemBackground).ignoresSafeArea() }
  }
}
