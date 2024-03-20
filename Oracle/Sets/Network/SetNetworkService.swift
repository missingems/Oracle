import Foundation
import ScryfallKit

struct QueryResponse {
  let sets: [any GameSet]
  let cardNames: [String]
}

final class SetNetworkService {
  private var client = ScryfallClient()
  
  func fetchSets(completion: @escaping (Result<[any GameSet], any Error>) -> ()) {
    client.getSets { result in
      switch result {
      case let .success(value):
        DispatchQueue.global().async {
          var data = value.data.filter { $0.digital == false && $0.numberOfCards != 0 }
          var sections = data.filter { $0.parentSetCode == nil }.map { [$0] }
          
          for (index, section) in sections.enumerated() {
            sections[index] = section + data.filter {
              $0.parentSetCode == section.first?.code && $0.cardCount != 0
            }
          }
          
          data = sections.flatMap { $0 }
          completion(.success(data))
        }
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  
  func query(
    _ query: String,
    sets: [any GameSet] = [],
    completion: @escaping (Result<QueryResponse, Error>) -> ()
  ) {
    var gameSets: [any GameSet] = [] {
      didSet {
        completion(.success(QueryResponse(sets: gameSets, cardNames: cardNames)))
      }
    }
    
    var cardNames: [String] = [] {
      didSet {
        completion(.success(QueryResponse(sets: gameSets, cardNames: cardNames)))
      }
    }
    
    querySets(
      query: query,
      in: sets
    ) { result in
      switch result {
      case let .success(value):
        gameSets = value
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
    
    queryCards(
      query: query
    ) { result in
      switch result {
      case let .success(value):
        cardNames = value
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  
  func querySets(
    query: String,
    in sets: [any GameSet],
    completion: @escaping (Result<[any GameSet], Error>) -> ()
  ) {
    func distanceFromTarget(_ string: String, target: Character) -> Int {
      guard let firstCharacter = string.uppercased().first else { return Int.max }
      return abs(Int(firstCharacter.asciiValue ?? 0) - Int(target.asciiValue ?? 0))
    }
    
    DispatchQueue.global().async { [weak self] in
      guard self != nil else {
        return
      }
      
      let lowercasedQuery = query.lowercased()
      
      let results = sets.filter {
        $0.name.lowercased().contains(lowercasedQuery)
      }.sorted {
        ($0.name.lowercased().hasPrefix(lowercasedQuery) ? 1 : 0) > ($1.name.lowercased().hasPrefix(lowercasedQuery) ? 1 : 0)
      }
      
      completion(.success(results))
    }
  }
  
  func queryCards(query: String, completion: @escaping (Result<[String], Error>) -> ()) {
    client.getCardNameAutocomplete(query: query) { [weak self] result in
      guard self != nil else {
        return
      }
      
      switch result {
      case let .success(value):
        completion(.success(value.data))
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}

enum SetNetworkServiceError: Error {
  case noQuery
  case noResult
}
