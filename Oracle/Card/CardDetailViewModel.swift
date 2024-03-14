import ScryfallKit
import Foundation

struct CardDetailViewModel {
  private let client: ScryfallClient
  let card: Card
  let set: any GameSet
  var selectedFace: Card.Face?
  private(set) var versions: [Card]
  
  var loyalty: String? {
    guard let loyalty = selectedFace?.loyalty ?? card.loyalty else {
      return nil
    }
    
    return String(localized: "Loyalty: \(loyalty)")
  }
  
  var powerToughness: String? {
    guard 
      let power = selectedFace?.power ?? card.power,
      let toughness = selectedFace?.toughness ?? card.toughness
    else {
      return nil
    }
    
    return "\(power)/\(toughness)"
  }
  
  var name: String? {
    if isPhyrexian {
      return selectedFace?.name ?? card.name
    } else {
      return selectedFace?.printedName ?? selectedFace?.name ?? card.printedName ?? card.name
    }
  }
  
  var text: NSAttributedString? {
    let attributedText: NSAttributedString?
    
    if isPhyrexian {
      let text = selectedFace?.oracleText ?? card.oracleText
      attributedText = text?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
    } else {
      let text = selectedFace?.printedText ?? selectedFace?.oracleText ?? card.printedText ?? card.oracleText
      attributedText = text?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
    }
    
    return (attributedText?.string.isEmpty == true) ? nil : attributedText
  }
  
  var typeLine: String? {
    if isPhyrexian {
      return selectedFace?.typeLine ?? card.typeLine
    } else {
      return selectedFace?.printedTypeLine ?? selectedFace?.typeLine ?? card.printedTypeLine ?? card.typeLine
    }
  }
  
  var manaCost: NSAttributedString? {
    let manaCost = selectedFace?.manaCost ?? card.manaCost
    return manaCost?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
  }
  
  var flavorText: String? {
    selectedFace?.flavorText ?? card.flavorText
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
  
  init(card: Card, set: any GameSet) {
    client = ScryfallClient(networkLogLevel: .minimal)
    self.card = card
    self.set = set
    self.selectedFace = card.cardFaces?.first
    versions = [card]
  }
  
  mutating func transformTapped() {
    if let faces = card.cardFaces {
      if selectedFace == faces.first {
        selectedFace = faces.last
      } else {
        selectedFace = faces.first
      }
    }
  }
  
  @MainActor
  mutating func fetchAllPrints() async {
    guard let oracleId = card.oracleId else {
      return
    }
    
    do {
      let result = try await client.searchCards(
        filters: [.oracleId(oracleId), .game(.paper)],
        unique: .prints,
        order: .released,
        sortDirection: .auto,
        includeExtras: true,
        includeMultilingual: false,
        includeVariations: true,
        page: nil
      )
      
      versions = result.data
    } catch {}
  }
}
