import ComposableArchitecture
import Foundation
import ScryfallKit

@Reducer
struct CardFeature {
  let client = ScryfallClient()
  
  @ObservableState
  struct State {
    let card: Card
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
    
    var manaCost: String? {
      selectedFace?.manaCost ?? card.manaCost
    }
    
    var flavorText: String? {
      card.isFlippable ? selectedFace?.flavorText : card.flavorText
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
      String(localized: "Illustrated by")
    }
    
    var viewRulingsLabel: String {
      String(localized: "View Rulings")
    }
    
    var legalities: [Card.Legality] {
      [
        card.legalities.standard,
        card.legalities.pioneer,
        card.legalities.modern,
        card.legalities.historic,
        card.legalities.legacy,
        card.legalities.brawl,
        card.legalities.vintage,
        card.legalities.commander,
        card.legalities.pauper,
        card.legalities.penny,
      ].compactMap { $0 }
    }
    
    var allLegalities: [Card.Legalities.LegalityType] {
      Card.Legalities.LegalityType.allCases
    }
  }
  
  enum Action {
    case viewAppeared
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .viewAppeared:
        return .none
      }
    }
  }
}
