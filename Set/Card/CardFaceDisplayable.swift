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
  var tokenisedManaCost: [String] { get }
}

extension CardFaceDisplayable {
  var tokenisedManaCost: [String] {
    if let manaCost = cost?.replacingOccurrences(of: "/", with: ":").replacingOccurrences(of: "∞", with: "INFINITY") {
      let regex = try? NSRegularExpression(pattern: "\\{[^}]+\\}", options: [])
      
      let matches = regex?.matches(
        in: manaCost,
        options: [],
        range: NSRange(location: 0, length: manaCost.utf16.count)
      )
      
      return matches?.compactMap { value in
        if let range = Range(value.range, in: manaCost) {
          return String(manaCost[range])
        } else {
          return nil
        }
      } ?? []
    } else {
      return []
    }
  }
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
