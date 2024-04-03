import ComposableArchitecture
import DesignComponent
import SwiftUI

struct CardView: View {
  let store: StoreOf<CardFeature>
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 11) {
        header
        content
      }
    }
    .background { Color(.secondarySystemBackground).ignoresSafeArea() }
  }
  
  @ViewBuilder
  private func legalityRow(index: Int, startingIndex: Int) -> some View {
    let legality = store.allLegalities[index]
    let value = store.card.legalities.type(legality)
    
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
        .shadow(color: value.1?.color.map { Color(uiColor: $0).opacity(0.38) } ?? Color.clear, radius: 5.0)
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
}

extension CardView {
  @ViewBuilder
  private var content: some View {
    VStack(alignment: .leading, spacing: 11) {
      nameAndManaCostRow
      typelineRow
      textRow
      flavorTextRow
      legalityRow
    }
    .background { Color(.secondarySystemBackground) }
  }
  
  @ViewBuilder
  private var header: some View {
    AmbientWebImage(
      url: store.cardImageURL,
      placeholderName: "mtgBack",
      cornerRadius: 15.0
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
        TokenizedTextView(mana, font: .preferredFont(forTextStyle: .body))
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
        Text(typeline).font(.body)
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
      TokenizedTextView(text, font: .preferredFont(forTextStyle: .body))
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
  
  private func makeDivider() -> some View {
    Divider()
      .padding(.leading, 16.0)
  }
}
