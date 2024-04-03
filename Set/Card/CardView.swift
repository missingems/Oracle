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
        footerView
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
      informationRow
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
        Text(name).font(.headline)
        Spacer()
        TokenizedTextView(mana, font: .preferredFont(forTextStyle: .body), paragraphSpacing: 8.0).offset(x: 0, y: 2)
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
      
      Text(typeline).font(.headline)
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
      
      HStack(spacing: 8.0) {
        VStack(spacing: 3.0) {
          ForEach(store.allLegalities.prefix(5).indices, id: \.self) { index in
            legalityRow(index: index, startingIndex: 0)
          }
        }
        
        VStack(spacing: 3.0) {
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
        .font(.caption)
        .background { color }
        .clipShape(ButtonBorderShape.roundedRectangle)
        .shadow(color: color?.opacity(0.38) ?? .clear, radius: 5.0)
      Text("\(value.0)")
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .font(.caption)
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
  private var informationRow: some View {
    makeDivider()
    
    VStack(alignment: .leading) {
      Text("Information").font(.headline)
        .padding(.horizontal, 16.0)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          powerAndToughnessWidgetView
          loyaltyWidgetView
          manaValueView
          setView
          collectionNumberView
        }
        .padding(.horizontal, 16.0)
      }
    }
  }
  
  @ViewBuilder
  private var powerAndToughnessWidgetView: some View {
    if let power = store.power, let toughness = store.toughness {
      VStack(alignment: .center) {
        HStack {
          Image("power")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.primary)
            .frame(height: UIFont.preferredFont(forTextStyle: .headline).pointSize + 8.0)
          
          Text("\(power)/\(toughness)").font(.body).fontDesign(.serif)
          
          Image("toughness")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.primary)
            .frame(height: UIFont.preferredFont(forTextStyle: .headline).pointSize + 8.0)
        }
        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
        .background {
          Color(.systemFill)
        }
        .clipShape(.buttonBorder)
        
        Text("Power\nToughness").font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
        Spacer(minLength: 0)
      }
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var setView: some View {
    if let cardSetImageURI = store.cardSetImageURI, let url = URL(string: cardSetImageURI) {
      VStack(alignment: .center) {
        HStack(spacing: 5.0) {
          IconWebImage(url).frame(width: 25, height: 25).tint(.primary)
          Text(store.card.set.uppercased()).font(.body).fontDesign(.serif)
        }
        .frame(minWidth: 66.125, minHeight: 25.0)
        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
        .background {
          Color(.systemFill)
        }
        .clipShape(.buttonBorder)
        
        Text("Set\nCode").font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
        Spacer(minLength: 0)
      }
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var collectionNumberView: some View {
    VStack(alignment: .center) {
      HStack {
        Text("#\(store.card.collectorNumber)".uppercased()).font(.body).fontDesign(.serif)
      }
      .frame(minWidth: 66.125, minHeight: 25.0)
      .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
      .background {
        Color(.systemFill)
      }
      .clipShape(.buttonBorder)
      
      Text("Collector\nNumber").font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
      Spacer(minLength: 0)
    }
  }
  
  @ViewBuilder
  private var manaValueView: some View {
    let string = store.card.colorIdentity.map { "{\($0.rawValue)}" }
    
    VStack(alignment: .center) {
      HStack(alignment: .center, spacing: 5.0) {
        ForEach(string.indices, id: \.self) { index in
          Image(string[index]).resizable().aspectRatio(contentMode: .fit).frame(height: 21.0)
        }
      }
      .frame(minWidth: 66.125, minHeight: 25.0)
      .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
      .background { Color(.systemFill) }
      .clipShape(.buttonBorder)
      
      Text("Color\nIdentity").font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
      Spacer(minLength: 0)
    }
  }
  
  @ViewBuilder
  private var loyaltyWidgetView: some View {
    if let loyalty = store.loyalty {
      VStack(alignment: .center) {
        HStack {
          ZStack(alignment: .center) {
            Image("loyalty")
              .resizable()
              .renderingMode(.template)
              .aspectRatio(contentMode: .fit)
              .tint(.accentColor)
            
            Text(loyalty).foregroundStyle(Color("capsule")).font(.headline).fontDesign(.serif)
          }
          .frame(minWidth: 66.125, minHeight: 25.0)
          .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
          .background {
            Color(.systemFill)
          }
          .clipShape(.buttonBorder)
        }
        
        Text("Loyalty\nCounters").font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
        Spacer(minLength: 0)
      }
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var illustratorRow: some View {
    if let artist = store.card.artist {
      NavigationLink {
        Text("Artist")
      } label: {
        Text(store.illstrautedLabel).font(.headline).tint(.primary)
        
        Spacer()
        
        HStack(alignment: .center, spacing: 5.0) {
          Image("artist")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 12)
          Text(artist).font(.body)
        }
        .tint(.secondary)
        
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
          VStack(spacing: 0) {
            Text("$\(usdPrice ?? "0.00")")
              .font(usdPrice == nil ? .body : .headline)
              .monospaced()
            Text("USD").font(.caption).tint(.secondary)
          }
          .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .disabled(usdPrice == nil)
        
        let usdFoilPrice = store.card.getPrice(for: .usdFoil)
        Button {
          print("Implement View Rulings")
        } label: {
          VStack(spacing: 0) {
            Text("$\(usdFoilPrice ?? "0.00")")
              .font(usdFoilPrice == nil ? .body : .headline)
              .monospaced()
            Text("USD - Foil").font(.caption).tint(.secondary)
          }
          .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .disabled(usdFoilPrice == nil)
        
        let tixPrice = store.card.getPrice(for: .tix)
        Button {
          print("Implement View Rulings")
        } label: {
          VStack(spacing: 0) {
            Text("\(tixPrice ?? "0.00")")
              .font(tixPrice == nil ? .body : .headline)
              .monospaced()
            Text("Tix").font(.caption).tint(.secondary)
          }
          .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .disabled(tixPrice == nil)
      }
    }
    .padding(.horizontal, 16.0)
  }
  
  @ViewBuilder
  private var printsRow: some View {
    makeDivider()
    
    VStack(alignment: .leading) {
      Text("Prints").font(.headline).padding(.horizontal, 16.0)
      Text("\(store.prints.count) Results").font(.caption).foregroundStyle(.secondary).padding(.horizontal, 16.0)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(store.prints) { card in
            NavigationLink(state: Feature.Path.State.showCard(CardFeature.State(card: card, cardSetImageURI: store.cardSetImageURI))) {
              LazyVStack(alignment: .center, spacing: 8.0) {
                AmbientWebImage(url: card.getImageURL(type: .normal), placeholderName: "mtgBack")
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 144, height: 144 * 1.3928)
                
                PillText("$\(card.getPrice(for: .usd) ?? "0.00")", insets: EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5)).font(.caption).monospaced()
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

