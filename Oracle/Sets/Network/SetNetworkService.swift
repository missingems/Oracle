//
//  SetsTableViewNetworkService.swift
//  Oracle
//
//  Created by Jun on 13/3/24.
//

import Foundation
import ScryfallKit

protocol SetNetworkService {
  func fetchSets(completion: @escaping (Result<[any GameSet], Error>) -> ())
  func querySets(query: String, in sets: [any GameSet], completion: @escaping (Result<[any GameSet], Error>) -> ())
  func queryCards(query: String, completion: @escaping (Result<[String], Error>) -> ())
}

extension ScryfallClient: SetNetworkService {
  func fetchSets(completion: @escaping (Result<[any GameSet], any Error>) -> ()) {
    getSets { result in
      switch result {
      case let .success(value):
        DispatchQueue.global().async {
          var data = value.data.filter { !$0.digital && $0.numberOfCards != 0 }
          var sections: [[MTGSet]] = data.filter { $0.parentSetCode == nil }.map { [$0]}
          
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
  
  func querySets(query: String, in sets: [any GameSet], completion: @escaping (Result<[any GameSet], Error>) -> ()) {
    func distanceFromTarget(_ string: String, target: Character) -> Int {
      guard let firstCharacter = string.uppercased().first else { return Int.max }
      return abs(Int(firstCharacter.asciiValue ?? 0) - Int(target.asciiValue ?? 0))
    }
    
    DispatchQueue.global().async { [weak self] in
      guard self != nil else {
        return
      }
      
      guard query.isEmpty == false else {
        completion(.failure(SetNetworkServiceError.noQuery))
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
    getCardNameAutocomplete(query: query) { [weak self] result in
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
