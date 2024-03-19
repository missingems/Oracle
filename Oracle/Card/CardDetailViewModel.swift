import ScryfallKit
import Foundation

final class CardDetailViewModel {
  let card: Card
  private let client: ScryfallClient
  private weak var coordinator: SetCoordinator?
  var selectedFace: Card.Face?
  var stateHandler: ((Message) -> ())?
  private(set) var versions: [Card]
  
  var loyalty: String? {
    guard let loyalty = card.flippable ? selectedFace?.loyalty : card.loyalty else {
      return nil
    }
    
    return String(localized: "Loyalty: \(loyalty)")
  }
  
  var powerToughness: String? {
    guard 
      let power = card.flippable ? selectedFace?.power : card.power,
      let toughness = card.flippable ? selectedFace?.toughness : card.toughness
    else {
      return nil
    }
    
    return "\(power)/\(toughness)"
  }
  
  var name: String? {
    if isPhyrexian {
      return card.flippable ? selectedFace?.name : card.name
    } else {
      return card.flippable ? selectedFace?.printedName ?? selectedFace?.name : card.printedName ?? card.name
    }
  }
  
  var backButtonItem: String? {
    "\(name ?? "") #\(card.collectorNumber)"
  }
  
  var text: NSAttributedString? {
    let attributedText: NSAttributedString?
    
    if isPhyrexian {
      let text = card.flippable ? selectedFace?.oracleText : card.oracleText
      attributedText = text?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
    } else {
      let text = card.flippable ? selectedFace?.printedText ?? selectedFace?.oracleText : card.printedText ?? card.oracleText
      attributedText = text?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
    }
    
    return (attributedText?.string.isEmpty == true) ? nil : attributedText
  }
  
  var typeLine: String? {
    if isPhyrexian {
      return card.flippable ? selectedFace?.typeLine : card.typeLine
    } else {
      return card.flippable ? selectedFace?.printedTypeLine ?? selectedFace?.typeLine : card.printedTypeLine ?? card.typeLine
    }
  }
  
  var manaCost: NSAttributedString? {
    let manaCost = selectedFace?.manaCost ?? card.manaCost
    return manaCost?.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
  }
  
  var flavorText: String? {
    card.flippable ? selectedFace?.flavorText : card.flavorText
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
  
  init(card: Card, coordinator: SetCoordinator) {
    self.coordinator = coordinator
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
        coordinator?.show(destination: .showCard(card))
      } else {
        stateHandler?(.shouldWiggleView)
      }
      
    case .viewDidLoad:
      fetchAllPrints()
    }
  }
  
  func transformTapped() {
    if let faces = card.cardFaces {
      if selectedFace == faces.first {
        selectedFace = faces.last
      } else {
        selectedFace = faces.first
      }
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
}

extension CardDetailViewModel {
  enum Event {
    case viewDidLoad
    case didSelectRulings
    case didSelectCard(Card)
  }
  
  enum Message {
    case shouldReconfigureCardDetailPage
    case shouldWiggleView
  }
}
