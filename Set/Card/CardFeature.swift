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
    var configuration: ContentConfiguration?
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
    
    var transformLabel: String? {
      if card.isRotatable {
        return String(localized: "Flip")
      }
      
      if card.isFlippable {
        return String(localized: "Transform")
      }
      
      return nil
    }
    
    let cardSetImageURL: URL?
    
    var selectedFace: any CardFaceDisplayable {
      didSet {
        reRenderCardViewIfNeeded()
      }
    }
    
    init(
      card: Card,
      cardSetImageURL: URL?
    ) {
      self.card = card
      
      if card.isFlippable, let cardFace = card.cardFaces?.first {
        selectedFace = cardFace
      } else {
        selectedFace = card
      }
      
      self.prints = [card]
      self.cardSetImageURL = cardSetImageURL
    }
    
    private mutating func reRenderCardViewIfNeeded() {
      configuration = ContentConfiguration(card: card, selectedFace: selectedFace)
    }
  }
  
  enum Action {
    case viewAppeared
    case showPrints([Card])
    case updateConfiguration(ContentConfiguration)
    case transformTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .updateConfiguration(configuration):
        state.configuration = configuration
        return .none
        
      case .viewAppeared:
        let configuration = ContentConfiguration(card: state.card, selectedFace: state.selectedFace)
        
        guard let oracleId = configuration.oracleId else {
          return .none
        }
        
        return .merge(
          .run { send in
            await send(.updateConfiguration(configuration))
          },
          .run { send in
            try await send(
              .showPrints(
                client.searchCards(
                  filters: [
                    .oracleId(oracleId)
                  ],
                  unique: .prints,
                  order: .released,
                  sortDirection: .auto,
                  includeExtras: true,
                  includeMultilingual: false,
                  includeVariations: true,
                  page: nil
                )
                .data
              )
            )
          }
          
        )
        
      case let .showPrints(cards):
        state.prints = cards
        return .none
        
      case .transformTapped:
        state.configuration = state.configuration?.toggled()
        return .none
      }
    }
  }
}

