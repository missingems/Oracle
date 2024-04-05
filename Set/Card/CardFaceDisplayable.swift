import Foundation
import ScryfallKit

protocol CardFaceDisplayable {
  var imageURL: URL? { get }
  var cmc: Double? { get }
  var name: String { get }
  var printedName: String? { get }
  var printedText: String? { get }
  var oracleText: String? { get }
  var typeLine: String? { get }
  var printedTypeLine: String? { get }
  var flavorText: String? { get }
  var power: String? { get }
  var toughness: String? { get }
  var loyalty: String? { get }
  var artist: String? { get }
  var cost: String? { get }
}

extension Card: CardFaceDisplayable {
  var cost: String? {
    manaCost
  }
  var imageURL: URL? {
    getImageURL(type: .normal)
  }
}

extension Card.Face: CardFaceDisplayable {
  var cost: String? {
    manaCost
  }
  
  var imageURL: URL? {
    if let uri = imageUris?.normal {
      return URL(string: uri)
    } else {
      return nil
    }
  }
}
