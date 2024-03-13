//
//  SetsTableViewNetworkService.swift
//  Oracle
//
//  Created by Jun on 13/3/24.
//

import Foundation
import ScryfallKit

protocol SetNetworkService {
  func fetchSets(_ completion: @escaping (Result<[any CardSet], Error>) -> ())
}

extension ScryfallClient: SetNetworkService {
  func fetchSets(_ completion: @escaping (Result<[any CardSet], any Error>) -> ()) {
    getSets { result in
      switch result {
      case let .success(value):
        var data = value.data.filter { !$0.digital && $0.numberOfCards != 0 }
        var sections: [[MTGSet]] = data.filter { $0.parentSetCode == nil }.map { [$0]}
        
        for (index, section) in sections.enumerated() {
          sections[index] = section + data.filter {
            $0.parentSetCode == section.first?.code && $0.cardCount != 0
          }
        }
        
        data = sections.flatMap { $0 }
        
        completion(.success(data))
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
