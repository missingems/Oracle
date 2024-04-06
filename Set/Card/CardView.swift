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
      url: [store.configuration?.imageURL],
      cornerRadius: 15.0,
      blurRadius: 44.0,
      offset: CGPoint(x: 0, y: 10),
      scale: CGSize(width: 1.1, height: 1.1)
    )
    .padding(EdgeInsets(top: 11, leading: 55, bottom: 11, trailing: 55))
  }
  
  @ViewBuilder
  private var nameAndManaCostRow: some View {
    if let name = store.configuration?.name {
      Divider()
      
      HStack(alignment: .center) {
        Text(name).font(.headline)
        Spacer()
        ManaView(
          identity: store.configuration?.manaCost ?? [],
          size: CGSize(width: 17, height: 17),
          spacing: 2.0
        )
      }
      .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var typelineRow: some View {
    if let typeline = store.configuration?.typeline {
      makeDivider()
      
      Text(typeline).font(.headline)
        .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var textRow: some View {
    if let text = store.configuration?.text {
      makeDivider()
      TokenizedTextView(text, font: .preferredFont(forTextStyle: .body), paragraphSpacing: 8.0)
        .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var flavorTextRow: some View {
    if let flavorText = store.configuration?.flavorText {
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
    let color = value.1?.color.map { $0 }
    
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
      Text("Information")
        .font(.headline)
        .padding(.horizontal, 16.0)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          if let power = store.configuration?.power, let toughness = store.configuration?.toughness {
            Widget.powerToughness(power: power, toughness: toughness).view
          }
          
          if let loyalty = store.configuration?.loyalty {
            Widget.loyalty(counters: loyalty).view
          }
          
          Widget.colorIdentity(store.configuration?.colorIdentity ?? []).view
          
          if let manaValue = store.configuration?.cmc {
            Widget.manaValue("\(manaValue)").view
          }
          
          Widget.setCode(store.card.set, iconURL: store.cardSetImageURL).view
          
          Widget.collectorNumber(rarity: "\(store.card.rarity.rawValue.prefix(1))", store.card.collectorNumber).view
        }
        .padding(.horizontal, 16.0)
      }
    }
  }
  
  @ViewBuilder
  private var illustratorRow: some View {
    if let artist = store.configuration?.artist {
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
        let usdPrice = store.configuration?.usdPrice
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
        
        let usdFoilPrice = store.configuration?.usdFoilPrice
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
        
        let tixPrice = store.configuration?.tixPrice
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
            NavigationLink(
              state: Feature.Path.State.showCard(
                CardFeature.State(
                  card: card, 
                  cardSetImageURL: store.cardSetImageURL
                )
              )
            ) {
              LazyVStack(alignment: .center, spacing: 8.0) {
                AmbientWebImage(url: [card.getImageURL(type: .normal)])
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
