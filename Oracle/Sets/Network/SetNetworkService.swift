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
        completion(.success(value.data.filter { !$0.digital && $0.numberOfCards != 0 }))
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
