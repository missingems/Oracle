//
//  SetsTableViewNetworkService.swift
//  Oracle
//
//  Created by Jun on 13/3/24.
//

import Foundation
import ScryfallKit

protocol SetsTableViewNetworkService {
  func fetchSets(_ completion: @escaping (Result<[any CardSet], Error>) -> ())
}

extension ScryfallClient: SetsTableViewNetworkService {
  func fetchSets(_ completion: @escaping (Result<[any CardSet], any Error>) -> ()) {
    self.getSets { result in
      switch result {
      case let .success(value):
        completion(.success(value.data))
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
