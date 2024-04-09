import ComposableArchitecture
import DesignComponent
import SwiftUI

struct CardView: View {
  let store: StoreOf<CardFeature>
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        header
        content
        Spacer(minLength: 13.0)
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
      if store.card.layout == .split {
        multiFaceContentView(leftFace: store.card.cardFaces?.first, rightFace: store.card.cardFaces?.last)
      } else if store.card.layout == .adventure {
        multiFaceContentView(leftFace: store.card.cardFaces?.last, rightFace: store.card.cardFaces?.first)
      } else {
        nameAndManaCostRow(name: store.configuration?.name, manaCost: store.configuration?.manaCost)
          .padding(.top, 13.0)
        typelineRow(typeline: store.configuration?.typeline)
        textRow(text: store.configuration?.text)
        flavorTextRow(flavorText: store.configuration?.flavorText)
      }
      
      informationRow
      legalityRow
      marketPriceRow
      printsRow
    }
    .background { Color(.secondarySystemBackground) }
  }
  
  @ViewBuilder
  private var header: some View {
    ZStack(alignment: .bottom) {
      AmbientWebImage(
        url: [store.configuration?.imageURL],
        cornerRadius: 15.0,
        blurRadius: 44.0,
        offset: CGPoint(x: 0, y: 10),
        scale: CGSize(width: 1.1, height: 1.1),
        rotation: store.card.layout == .split ? 90 : 0,
        transaction: Transaction(animation: nil), 
        width: 300
      )
      .padding(EdgeInsets(top: 13, leading: 55, bottom: 21, trailing: 55))
      
      Divider()
    }
  }
  
  @ViewBuilder
  func nameAndManaCostRow(name: String?, manaCost: [String]?) -> some View {
    if let name {
      HStack(alignment: .top) {
        Text(name)
          .font(.headline)
          .multilineTextAlignment(.leading)
        
        Spacer()
        
        ManaView(
          identity: manaCost ?? [],
          size: CGSize(width: 17, height: 17),
          spacing: 2.0
        )
        .offset(CGSize(width: 0, height: 1))
      }
      .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  func typelineRow(typeline: String?, shouldRenderDivider: Bool = true) -> some View {
    if let typeline {
      if shouldRenderDivider {
        makeDivider()
      }
      
      Text(typeline)
        .font(.headline)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  func textRow(text: String?, shouldRenderDivider: Bool = true) -> some View {
    if let text {
      if shouldRenderDivider {
        makeDivider()
      }
      
      TokenizedTextView(text, font: .preferredFont(forTextStyle: .body), paragraphSpacing: 8.0)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16.0)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  func flavorTextRow(flavorText: String?, shouldRenderDivider: Bool = true) -> some View {
    if let flavorText {
      if shouldRenderDivider {
        makeDivider()
      }
      
      Text(flavorText)
        .font(.body)
        .fontDesign(.serif)
        .italic()
        .foregroundStyle(Color.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
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
            NavigationCardImageView(
              imageURLs: card.imageURLs,
              linkState: Feature.Path.State.showCard(CardFeature.State(card: card, cardSetImageURL: store.cardSetImageURL)),
              shouldShowTransformButton: card.isFlippable,
              width: 144
            ) {
              Group {
                if let usd = card.getPrice(for: .usd) {
                  PillText(
                    "$\(usd)",
                    insets: EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5)
                  )
                } else if let usdFoil = card.getPrice(for: .usd) {
                  PillText(
                    "$\(usdFoil)",
                    insets: EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5)
                  )
                } else {
                  PillText(
                    "\(card.rarity.rawValue.prefix(1))#\(card.collectorNumber)".uppercased(),
                    insets: EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5),
                    background: Color.clear
                  )
                }
              }
              .font(.caption)
              .fontWeight(.medium)
              .monospaced()
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
