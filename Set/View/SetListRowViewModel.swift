import Foundation
import ScryfallKit

struct SetListRowViewModel: Equatable {
  let childIndicatorImageName: String
  let disclosureIndicatorImageName: String
  let iconUrl: URL?
  let id: String
  let isParent: Bool
  let numberOfCardsLabel: String
  let shouldSetBackground: Bool
  let title: String
  
  init(set: MTGSet, shouldSetBackground: Bool) {
    childIndicatorImageName = "arrow.turn.down.right"
    disclosureIndicatorImageName = "chevron.right"
    iconUrl = URL(string: set.iconSvgUri)
    id = set.code.uppercased()
    isParent = set.parentSetCode != nil
    numberOfCardsLabel = String(localized: "\(set.cardCount) Cards")
    self.shouldSetBackground = shouldSetBackground
    title = set.name
  }
}
