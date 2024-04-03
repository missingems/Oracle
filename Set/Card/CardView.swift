import ComposableArchitecture
import DesignComponent
import SwiftUI

struct CardView: View {
  let store: StoreOf<CardFeature>
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 13) {
        header
        content
      }
      .padding(.bottom, 13.0)
    }
    .background { Color(.secondarySystemBackground).ignoresSafeArea() }
    .onAppear {
      store.send(.viewAppeared)
    }
  }
}

extension CardView {
  @ViewBuilder
  private var content: some View {
    VStack(alignment: .leading, spacing: 13) {
      nameAndManaCostRow
      typelineRow
      textRow
      flavorTextRow
      powerAndToughnessRow
      loyaltyRow
      illustratorRow
      legalityRow
      marketPriceRow
      printsRow
    }
    .background { Color(.secondarySystemBackground) }
  }
  
  @ViewBuilder
  private var header: some View {
    AmbientWebImage(
      url: store.cardImageURL,
      placeholderName: "mtgBack",
      cornerRadius: 15.0,
      blurRadius: 44.0,
      offset: CGPoint(x: 0, y: 10),
      scale: CGSize(width: 1.1, height: 1.1)
    )
    .padding(EdgeInsets(top: 11, leading: 55, bottom: 11, trailing: 55))
  } 
  
  @ViewBuilder
  private var nameAndManaCostRow: some View {
    if let name = store.name, let mana = store.manaCost {
      Divider()
      
      HStack(alignment: .center) {
        Text(name).font(.title2).bold()
        Spacer()
        TokenizedTextView(mana, font: .preferredFont(forTextStyle: .body), paragraphSpacing: 8.0)
      }
      .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var typelineRow: some View {
    if let typeline = store.typeLine {
      makeDivider()
      
      HStack {
        Text(typeline).font(.headline)
        Spacer()
        IconWebImage(URL(string: store.cardSetImageURI!)).frame(width: 21, height: 21)
      }
      .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var textRow: some View {
    if let text = store.text {
      makeDivider()
      TokenizedTextView(text, font: .preferredFont(forTextStyle: .body), paragraphSpacing: 8.0)
        .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var flavorTextRow: some View {
    if let flavorText = store.flavorText {
      makeDivider()
      Text(flavorText)
        .font(.body)
        .fontDesign(.serif)
        .italic()
        .foregroundStyle(Color.secondary)
        .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var legalityRow: some View {
    makeDivider()
    
    VStack(alignment: .leading) {
      Text(store.legalityLabel).font(.headline)
      Text(store.displayReleasedDate).font(.caption).foregroundStyle(.secondary)
      
      HStack(spacing: 5.0) {
        VStack(spacing: 2.0) {
          ForEach(store.allLegalities.prefix(5).indices, id: \.self) { index in
            legalityRow(index: index, startingIndex: 0)
          }
        }
        
        VStack(spacing: 2.0) {
          ForEach(store.allLegalities.suffix(5).indices, id: \.self) { index in
            legalityRow(index: index, startingIndex: 5)
          }
        }
      }
    }
    .padding(.horizontal, 16.0)
  }
  
  @ViewBuilder
  private func legalityRow(index: Int, startingIndex: Int) -> some View {
    let legality = store.allLegalities[index]
    let value = store.card.legalities.type(legality)
    let color = value.1?.color.map { Color(uiColor: $0) }
    
    HStack {
      Text("\(value.1?.localisedDescription ?? "")")
        .foregroundStyle(Color.white)
        .frame(minWidth: 0, maxWidth: .infinity).font(.system(size: 12))
        .padding(.vertical, 5.0)
        .font(.system(size: 12, weight: .medium))
        .monospaced()
        .background { color }
        .clipShape(ButtonBorderShape.roundedRectangle)
        .shadow(color: color?.opacity(0.38) ?? .clear, radius: 5.0)
      Text("\(value.0)")
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .font(.system(size: 12, weight: .regular))
        .multilineTextAlignment(.leading)
    }
    .background {
      if (index - startingIndex).isMultiple(of: 2) {
        Color.quaternarySystemFill.clipShape(ButtonBorderShape.roundedRectangle)
      } else {
        Color.clear
      }
    }
  }
  
  @ViewBuilder
  private var powerAndToughnessRow: some View {
    if let power = store.power, let toughness = store.toughness {
      makeDivider()
      
      HStack {
        HStack {
          Image("power")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.accentColor)
            .frame(height: UIFont.preferredFont(forTextStyle: .headline).pointSize + 8.0)
          
          Text("\(power)/\(toughness)").font(.headline).fontDesign(.serif)
          
          Image("toughness")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.accentColor)
            .frame(height: UIFont.preferredFont(forTextStyle: .headline).pointSize + 8.0)
        }
        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
        .background {
          Color(.systemFill)
        }
        .clipShape(.buttonBorder)
      }
      .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var loyaltyRow: some View {
    if let loyalty = store.loyalty {
      makeDivider()
      
      HStack {
        ZStack(alignment: .center) {
          Image("loyalty")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .tint(.accentColor)
            .frame(height: UIFont.preferredFont(forTextStyle: .headline).pointSize + 8.0)
          
          Text(loyalty).foregroundStyle(Color("capsule")).font(.headline).fontDesign(.serif)
        }
        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
        .background {
          Color(.systemFill)
        }
        .clipShape(.buttonBorder)
      }
      .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var illustratorRow: some View {
    if let artist = store.card.artist {
      makeDivider()
      
      NavigationLink {
        Text("Artist")
      } label: {
        VStack(alignment: .leading, spacing: 2.0) {
          Text(store.illstrautedLabel).font(.headline).tint(.primary)
          
          HStack(alignment: .center, spacing: 5.0) {
            Image("artist")
              .renderingMode(.template)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 12)
            Text(artist).font(.caption)
          }
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .tint(.tertiaryLabel)
          .fontWeight(.medium)
          .imageScale(.small)
      }
      .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var marketPriceRow: some View {
    makeDivider()
    
    VStack(alignment: .leading) {
      Text("Market Prices").font(.headline)
      Text("Data from Scryfall").font(.caption).foregroundStyle(.secondary)
      
      HStack(alignment: .center, spacing: 5.0) {
        let usdPrice = store.card.getPrice(for: .usd)
        Button {
          print("Implement View Rulings")
        } label: {
          VStack {
            Text("$\(usdPrice ?? "0.00")").monospaced()
            Text("USD").font(.caption).foregroundStyle(.secondary)
          }
          .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        
        let usdFoilPrice = store.card.getPrice(for: .usdFoil)
        Button {
          print("Implement View Rulings")
        } label: {
          VStack {
            Text("$\(usdFoilPrice ?? "0.00")").monospaced()
            Text("USD - Foil").font(.caption).foregroundStyle(.secondary)
          }
          .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        
        let tixPrice = store.card.getPrice(for: .tix)
        Button {
          print("Implement View Rulings")
        } label: {
          VStack {
            Text("\(tixPrice ?? "0.00")").monospaced()
            Text("Tix").font(.caption).foregroundStyle(.secondary)
          }
          .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
      }
    }
    .padding(.horizontal, 16.0)
  }
  
  @ViewBuilder
  private var printsRow: some View {
    makeDivider()
    
    VStack(alignment: .leading) {
      Text("Variants").font(.headline).padding(.horizontal, 16.0)
      Text("\(store.prints.count) Results").font(.caption).foregroundStyle(.secondary).padding(.horizontal, 16.0)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(store.prints) { card in
            NavigationLink(state: Feature.Path.State.showCard(CardFeature.State(card: card, cardSetImageURI: store.cardSetImageURI))) {
              LazyVStack(alignment: .center, spacing: 8.0) {
                AmbientWebImage(url: card.getImageURL(type: .normal), placeholderName: "mtgBack")
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 144, height: 144 * 1.3928)
                
                PillText("$\(card.getPrice(for: .usd) ?? "0.00")").font(.caption).monospaced()
              }
            }
          }
        }
        .padding(.horizontal, 16.0)
      }
      .scrollClipDisabled(true)
    }
  }
  
  private func makeDivider() -> some View {
    Divider()
      .padding(.leading, 16.0)
  }
}
