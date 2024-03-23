import ScryfallKit

protocol Network {
  func fetchMagicTheGatheringSets() async -> ObjectList<MTGSet>
}
