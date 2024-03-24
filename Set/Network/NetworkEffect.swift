import ScryfallKit

struct NetworkEffect {
  private let client: ScryfallClient
  
  init(client: ScryfallClient) {
    self.client = client
  }
  
  func fetchSets() async throws -> [MTGSet] {
    do {
      let list = try await client.getSets()
      
      var data = list.data.filter { $0.digital == false && $0.cardCount != 0 }
      var sections = data.filter { $0.parentSetCode == nil }.map { [$0] }
      
      for (index, section) in sections.enumerated() {
        sections[index] = section + data.filter {
          $0.parentSetCode == section.first?.code && $0.cardCount != 0
        }
      }
      
      data = sections.flatMap { $0 }
      return data
    } catch {
      throw error
    }
  }
}
