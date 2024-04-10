import ScryfallKit
import Foundation

extension CardFeature {
  struct ContentConfiguration: Equatable {
    let oracleId: String?
    let name: String?
    let text: String?
    let typeline: String?
    let flavorText: String?
    let cmc: Double?
    let imageURL: URL?
    let power: String?
    let toughness: String?
    let loyalty: String?
    let artist: String?
    let colorIdentity: [String]
    let manaCost: [String]
    let usdPrice: String?
    let usdFoilPrice: String?
    let tixPrice: String?
    let isLandscape: Bool
    private let card: Card
    private(set) var selectedFaceIndex: Int?
    
    init(card: Card, selectedFace: CardFaceDisplayable?, selectedFaceIndex: Int? = 0) {
      self.card = card
      self.isLandscape = card.isLandscape
      oracleId = card.oracleId
      imageURL = selectedFace?.imageURL ?? card.getImageURL(type: .normal)
      
      if card.isPhyrexian {
        name = selectedFace?.name
        text = selectedFace?.oracleText
        typeline = selectedFace?.typeLine
      } else {
        name = selectedFace?.printedName ?? selectedFace?.name
        text = selectedFace?.printedText ?? selectedFace?.oracleText
        typeline = selectedFace?.printedTypeLine ?? selectedFace?.typeLine
      }
      
      power = selectedFace?.power
      toughness = selectedFace?.toughness
      flavorText = selectedFace?.flavorText
      loyalty = selectedFace?.loyalty
      artist = selectedFace?.artist
      
      let colorIdentity = card.colorIdentity.map { "{\($0.rawValue)}" }
      if colorIdentity.isEmpty {
        self.colorIdentity = ["{C}"]
      } else {
        self.colorIdentity = colorIdentity
      }
      
      manaCost = selectedFace?.tokenisedManaCost ?? []
      usdPrice = card.getPrice(for: .usd)
      usdFoilPrice = card.getPrice(for: .usdFoil)
      tixPrice = card.getPrice(for: .tix)
      cmc = card.cmc
      self.selectedFaceIndex = selectedFaceIndex
    }
    
    func toggled() -> Self {
      if selectedFaceIndex == 0 {
        return ContentConfiguration(card: self.card, selectedFace: card.cardFaces?.last, selectedFaceIndex: 1)
      } else {
        return ContentConfiguration(card: self.card, selectedFace: card.cardFaces?.first, selectedFaceIndex: 0)
      }
    }
  }
}
