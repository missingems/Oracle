import ScryfallKit
import UIKit

extension Card.Legalities {
  enum LegalityType {
    case standard
    case modern
    case vintage
    case legacy
    case historic
    case commander
    case pauper
    case pioneer
    case brawl
    case penny
  }
  
  func type(_ type: LegalityType) -> (String, Card.Legality?) {
    switch type {
    case .standard:
      return ("Standard", self.standard)
    case .modern:
      return ("Modern", self.modern)
    case .vintage:
      return ("Vintage", self.vintage)
    case .legacy:
      return ("Legacy", self.legacy)
    case .historic:
      return ("Historic", self.historic)
    case .commander:
      return ("Commander", self.commander)
    case .pauper:
      return ("Pauper", self.pauper)
    case .pioneer:
      return ("Pioneer", self.pioneer)
    case .brawl:
      return ("Brawl", self.brawl)
    case .penny:
      return ("Penny", self.penny)
    }
  }
}

extension Card {
  var isFlippable: Bool {
    layout == .transform ||
    layout == .modalDfc ||
    layout == .reversibleCard ||
    layout == .doubleSided ||
    layout == .doubleFacedToken ||
    layout == .battle
  }
  
  var isRotatable: Bool {
    layout == .flip
  }
  
  var isLandscape: Bool {
    layout == .split
  }
}

extension Card.Legality {
  var color: UIColor {
    switch self {
    case .banned:
      return .banned
      
    case .legal:
      return .legal
      
    case .restricted:
      return .restricted
      
    case .notLegal:
      return .notLegal
    }
  }
  
  var localisedDescription: String {
    switch self {
    case .banned:
      return String(localized: "Banned")
      
    case .legal:
      return String(localized: "Legal")
      
    case .notLegal:
      return String(localized: "Not Legal")
      
    case .restricted:
      return String(localized: "Restricted")
    }
  }
}
