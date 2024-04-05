import SwiftUI

public enum Widget {
  case powerToughness(power: String, toughness: String)
  case loyalty(counters: String)
  case manaValue(String)
  case collectorNumber(rarity: String, String)
  case colorIdentity([String])
  case setCode(String, iconURL: URL?)
  
  @ViewBuilder
  public var view: some View {
    switch self {
    case let .powerToughness(power, toughness):
      powerToughnessView(power, toughness)
      
    case let .setCode(code, iconURL):
      setCodeView(code, iconURL)
      
    case let .colorIdentity(manaIdentity):
      manaIdentityView(manaIdentity)
      
    case let .collectorNumber(rarity, number):
      collectionNumberView(rarity: rarity, number: number)
      
    case let .loyalty(counters):
      loyaltyWidgetView(counters)
      
    case let .manaValue(value):
      manaValueView(value)
    }
  }
}

private extension Widget {
  @ViewBuilder
  func powerToughnessView(_ power: String, _ toughness: String) -> some View {
    VStack(alignment: .center) {
      content {
        Image("power")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(Color.primary)
        
        Text("\(power)/\(toughness)")
          .font(.body)
          .fontDesign(.serif)
        
        Image("toughness")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(Color.primary)
      }
      
      Text(String(localized: "Power\nToughness"))
        .font(.caption2)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Spacer(minLength: 0)
    }
  }
  
  @ViewBuilder
  private func manaIdentityView(_ identity: [String]) -> some View {
    VStack(alignment: .center) {
      content {
        ManaView(identity: identity, size: CGSize(width: 21, height: 21))
      }
      
      Text(String(localized: "Color\nIdentity"))
        .font(.caption2)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Spacer(minLength: 0)
    }
  }
  
  @ViewBuilder
  private func loyaltyWidgetView(_ counters: String) -> some View {
    VStack(alignment: .center) {
      content {
        ZStack(alignment: .center) {
          Image("loyalty")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .tint(.accentColor)
          
          Text(counters)
            .foregroundStyle(Color("capsule"))
            .font(.headline)
            .fontDesign(.serif)
        }
      }
      
      Text(String(localized: "Loyalty\nCounters"))
        .font(.caption2)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Spacer(minLength: 0)
    }
  }
  
  @ViewBuilder
  private func collectionNumberView(rarity: String, number: String) -> some View {
    VStack(alignment: .center) {
      content {
        Text("\(rarity) #\(number)".uppercased()).font(.body).fontDesign(.serif)
      }
      
      Text(String(stringLiteral: "Collector\nNumber"))
        .font(.caption2)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Spacer(minLength: 0)
    }
  }
  
  @ViewBuilder
  func setCodeView(_ code: String, _ iconURL: URL?) -> some View {
    VStack(alignment: .center) {
      content {
        IconWebImage(iconURL).frame(width: 25, height: 25).tint(.primary)
        Text(code.uppercased()).font(.body).fontDesign(.serif)
      }
      
      Text(String(localized: "Set\nCode"))
        .font(.caption2)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Spacer(minLength: 0)
    }
  }
  
  @ViewBuilder
  func manaValueView(_ manaValue: String) -> some View {
    VStack(alignment: .center) {
      content {
        Text(manaValue).font(.body).fontDesign(.serif)
      }
      
      Text(String(localized: "Mana\nValue"))
        .font(.caption2)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Spacer(minLength: 0)
    }
  }
}

extension Widget {
  @ViewBuilder
  private func content(@ViewBuilder content: () -> some View) -> some View {
    HStack(spacing: 5.0) {
      content()
    }
    .frame(minWidth: 66, minHeight: 32)
    .padding(EdgeInsets(top: 5, leading: 11, bottom: 5, trailing: 11))
    .background { Color(.systemFill) }
    .clipShape(.buttonBorder)
  }
}
