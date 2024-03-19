import ScryfallKit
import Foundation

final class CardDetailViewModel {
  let card: Card
  private let client: ScryfallClient
  private weak var coordinator: SetCoordinator?
  var selectedFace: Card.Face?
  var stateHandler: ((Message) -> ())?
  var set: (any GameSet)?
  private(set) var versions: [Card]
  
  var loyalty: String? {
    guard let loyalty = card.isFlippable ? selectedFace?.loyalty : card.loyalty else {
      return nil
    }
    
    return String(localized: "Loyalty: \(loyalty)")
  }
  
  var powerToughness: String? {
    guard 
      let power = card.isFlippable ? selectedFace?.power : card.power,
      let toughness = card.isFlippable ? selectedFace?.toughness : card.toughness
    else {
      return nil
    }
    
    return "\(power)/\(toughness)"
  }
  
  var name: String? {
    if isPhyrexian {
      return card.isFlippable ? selectedFace?.name : card.name
    } else {
      return card.isFlippable ? selectedFace?.printedName ?? selectedFace?.name : card.printedName ?? card.name
    }
  }
  
  var backButtonItem: String? {
    "\(name ?? "") #\(card.collectorNumber)"
  }
  
  var text: NSAttributedString? {
    let attributedText: NSAttributedString?
    
    if isPhyrexian {
      let text = card.isFlippable ? selectedFace?.oracleText : card.oracleText
      attributedText = text?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
    } else {
      let text = card.isFlippable ? selectedFace?.printedText ?? selectedFace?.oracleText : card.printedText ?? card.oracleText
      attributedText = text?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
    }
    
    return (attributedText?.string.isEmpty == true) ? nil : attributedText
  }
  
  var typeLine: String? {
    if isPhyrexian {
      return card.isFlippable ? selectedFace?.typeLine : card.typeLine
    } else {
      return card.isFlippable ? selectedFace?.printedTypeLine ?? selectedFace?.typeLine : card.printedTypeLine ?? card.typeLine
    }
  }
  
  var manaCost: NSAttributedString? {
    let manaCost = selectedFace?.manaCost ?? card.manaCost
    return manaCost?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
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
  
  init(card: Card, set: (any GameSet)?, coordinator: SetCoordinator) {
    self.coordinator = coordinator
    self.set = set
    client = ScryfallClient(networkLogLevel: .minimal)
    self.card = card
    self.selectedFace = card.cardFaces?.first
    versions = [card]
  }
  
  func update(_ event: Event) {
    switch event {
    case .didSelectRulings:
      coordinator?.present(destination: .showRulings(card: card))
      
    case let .didSelectCard(card):
      if card.id != self.card.id {
        coordinator?.show(destination: .showCard(card, set: nil))
      } else {
        stateHandler?(.shouldWiggleView)
      }
      
    case .viewDidLoad:
      fetchAllPrints()
      fetchCardIfNeeded()
      
    case .transformTapped:
      if let faces = card.cardFaces {
        if selectedFace == faces.first {
          selectedFace = faces.last
        } else {
          selectedFace = faces.first
        }
      }
      
      stateHandler?(.shouldReconfigureCardDetailPage)
    }
  }
  
  func fetchAllPrints() {
    guard let oracleId = card.oracleId else { return }
    
    client.searchCards(
      filters: [.oracleId(oracleId), .game(.paper)],
      unique: .prints,
      order: .released,
      sortDirection: .auto,
      includeExtras: true,
      includeMultilingual: false,
      includeVariations: true,
      page: nil
    ) { result in
      DispatchQueue.main.async { [weak self] in
        switch result {
        case let .success(value):
          self?.versions = value.data
          self?.stateHandler?(.shouldReconfigureCardDetailPage)
          
        case .failure:
          break
        }
      }
    }
  }
  
  func fetchCardIfNeeded() {
    guard set == nil else {
      return
    }
    
    client.getSet(identifier: .code(code: card.set)) { result in
      DispatchQueue.main.async { [weak self] in
        switch result {
        case let .success(set):
          self?.set = set
          self?.stateHandler?(.shouldReconfigureCardDetailPage)
          
        case .failure:
          break
        }
      }
    }
  }
}

extension CardDetailViewModel {
  enum Event {
    case viewDidLoad
    case didSelectRulings
    case didSelectCard(Card)
    case transformTapped
  }
  
  enum Message {
    case shouldReconfigureCardDetailPage
    case shouldWiggleView
  }
}
