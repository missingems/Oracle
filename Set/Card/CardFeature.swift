import ComposableArchitecture
import Foundation
import ScryfallKit

@Reducer
struct CardFeature {
  let client = ScryfallClient()
  
  struct FooterConfiguration: Identifiable {
    let id: UUID = UUID()
    let iconName: String?
    let systemIconName: String?
    let title: String
    let detail: String
    
    init(iconName: String? = nil, systemIconName: String? = nil, title: String, detail: String) {
      self.iconName = iconName
      self.systemIconName = systemIconName
      self.title = title
      self.detail = detail
    }
  }
  
  @ObservableState
  struct State {
    let card: Card
    let cardSetImageURI: String?
    var prints: [Card]
    
    var footerConfigurations: [FooterConfiguration] {
      [
        FooterConfiguration(
          iconName: "artist", 
          title: String(localized: "Artist"),
          detail: card.artist ?? ""
        ),
        FooterConfiguration(
          iconName: nil,
          systemIconName: "text.book.closed.fill",
          title: String(localized: "Rulings"),
          detail: String(localized: "View")
        ),
        FooterConfiguration(
          iconName: nil,
          systemIconName: "ellipsis.circle",
          title: String(localized: "Related"),
          detail: String(localized: "View")
        )
      ]
    }
    
    var selectedFace: Card.Face? {
      card.cardFaces?.first
    }
    
    var name: String? {
      if isPhyrexian {
        return card.isFlippable ? selectedFace?.name : card.name
      } else {
        return card.isFlippable ? selectedFace?.printedName ?? selectedFace?.name : card.printedName ?? card.name
      }
    }
    
    var text: String? {
      let text: String?
      
      if isPhyrexian {
        text = card.isFlippable ? selectedFace?.oracleText : card.oracleText
      } else {
        text = card.isFlippable ? selectedFace?.printedText ?? selectedFace?.oracleText : card.printedText ?? card.oracleText
        
      }
      
      return (text?.isEmpty == true) ? nil : text
    }
    
    var typeLine: String? {
      if isPhyrexian {
        return card.isFlippable ? selectedFace?.typeLine : card.typeLine
      } else {
        return card.isFlippable ? selectedFace?.printedTypeLine ?? selectedFace?.typeLine : card.printedTypeLine ?? card.typeLine
      }
    }
    
    var manaCost: [String] {
      guard let manaCost = card.manaCost else {
        return []
      }
      
      let regex = try? NSRegularExpression(pattern: "\\{[^}]+\\}", options: [])
      
      let matches = regex?.matches(
        in: manaCost,
        options: [],
        range: NSRange(location: 0, length: manaCost.utf16.count)
      )
      
      let results = matches?.compactMap { result -> String in
        let range = Range(result.range, in: manaCost)!
        return String(manaCost[range])
      }
      
      return results ?? []
    }
    
    var flavorText: String? {
      card.isFlippable ? selectedFace?.flavorText : card.flavorText
    }
    
    var loyalty: String? {
      guard let loyalty = card.isFlippable ? selectedFace?.loyalty : card.loyalty else {
        return nil
      }
      
      return loyalty
    }
    
    var power: String? {
      guard let power = card.isFlippable ? selectedFace?.power : card.power else {
        return nil
      }
      
      return power
    }
    
    var toughness: String? {
      guard let toughness = card.isFlippable ? selectedFace?.toughness : card.toughness else {
        return nil
      }
      
      return toughness
    }
    
    var cardImageURL: URL? {
      guard let uri = selectedFace?.imageUris?.normal ?? card.imageUris?.normal else {
        return nil
      }
      
      return URL(string: uri)
    }
    
    var isPhyrexian: Bool {
      card.lang == "ph"
    }
    
    var isTransformable: Bool {
      card.cardFaces?.isEmpty == false
    }
    
    var artist: String? {
      selectedFace?.artist ?? card.artist
    }
    
    var illstrautedLabel: String {
      String(localized: "Artist")
    }
    
    var viewRulingsLabel: String {
      String(localized: "Rulings")
    }
    
    var legalityLabel: String {
      String(localized: "Legality")
    }
    
    var allLegalities: [Card.Legalities.LegalityType] {
      Card.Legalities.LegalityType.allCases
    }
    
    var displayReleasedDate: String {
      String(localized: "Release Date: \(card.releasedAt)")
    }
    
    init(
      card: Card,
      cardSetImageURI: String?
    ) {
      self.card = card
      self.cardSetImageURI = cardSetImageURI
      self.prints = [card]
    }
  }
  
  enum Action {
    case viewAppeared
    case showPrints([Card])
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .viewAppeared:
        guard let oracleId = state.card.oracleId else {
          return .none
        }
        return .run { send in
          let value = try await client.searchCards(filters: [.oracleId(oracleId)], unique: .prints, order: .released, sortDirection: .auto, includeExtras: true, includeMultilingual: false, includeVariations: true, page: nil)
          await send(.showPrints(value.data))
        }
        
      case let .showPrints(cards):
        state.prints = cards
        return .none
      }
    }
  }
}
