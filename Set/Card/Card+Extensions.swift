import SwiftUI
import ScryfallKit

extension Card.Legalities {
  enum LegalityType: CaseIterable, Identifiable {
    var id: Self {
      return self
    }
    
    case standard
    case pioneer
    case modern
    case vintage
    case legacy
    case commander
    case pauper
    case historic
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
    layout == .battle ||
    layout == .flip
  }
  
  var isRotatable: Bool {
    layout == .flip
  }
  
  var isLandscape: Bool {
    layout == .split
  }
  
  var isPhyrexian: Bool {
    lang == "ph"
  }
}

extension Card.Legality {
  var color: Color? {
    switch self {
    case .banned:
      return Color("banned")
      
    case .legal:
      return Color("legal")
      
    case .restricted:
      return Color("restricted")
      
    case .notLegal:
      return Color("notLegal")
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

extension Card {
  var cardhoarderPurchaseURL: (title: String, url: URL?)? {
    if let value = purchaseUris?["cardhoarder"] {
      return (title: "CardHoarder", url: URL(string: value))
    } else {
      return nil
    }
  }
  
  var tcgPlayerPurchaseURL: (title: String, url: URL?)? {
    if let value = purchaseUris?["tcgplayer"] {
      return (title: "TCGPlayer", url: URL(string: value))
    } else {
      return nil
    }
  }
  
  var cardmarketPurchaseURL: (title: String, url: URL?)? {
    if let value = purchaseUris?["cardmarket"] {
      return (title: "CardMarket", url: URL(string: value))
    } else {
      return nil
    }
  }
}
