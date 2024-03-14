import ScryfallKit

final class SetDetailCollectionViewModel {
  private let client: any SetDetailNetworkService
  
  let title: String
  let set: any GameSet
  let subtitle: String
  
  init(
    set: any GameSet,
    client: any SetDetailNetworkService
  ) {
    self.set = set
    title = set.name
    subtitle = String(localized: "\(set.numberOfCards) Cards")
    self.client = client
  }
}
