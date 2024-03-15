//
//  SetDetailNetworkService.swift
//  Oracle
//
//  Created by Jun on 14/3/24.
//

import Foundation
import ScryfallKit

protocol SetDetailNetworkService {
  func fetchSetDetail(gameSet: any GameSet, page: Int, sort: SortMode, direction: SortDirection, completion: @escaping (Result<(cards: [Card], hasNext: Bool), Error>) -> ())
  func fetchCards(cardName: String, page: Int, sort: SortMode, direction: SortDirection, completion: @escaping (Result<(cards: [Card], hasNext: Bool), Error>) -> ())
}

extension ScryfallClient: SetDetailNetworkService {
  func fetchSetDetail(gameSet: any GameSet, page: Int, sort: SortMode, direction: SortDirection, completion: @escaping (Result<(cards: [Card], hasNext: Bool), Error>) -> ()) {
    searchCards(
      filters: [.set(gameSet.code), .game(.paper)],
      unique: .prints,
      order: sort,
      sortDirection: direction,
      includeExtras: true,
      includeMultilingual: false,
      includeVariations: true,
      page: page
    ) { result in
      switch result {
      case let .success(value):
        completion(.success((value.data, value.hasMore == true)))
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  
  func fetchCards(cardName: String, page: Int, sort: SortMode, direction: SortDirection, completion: @escaping (Result<(cards: [Card], hasNext: Bool), Error>) -> ()) {
    searchCards(
      filters: [.name(cardName), .game(.paper)],
      unique: .prints,
      order: sort,
      sortDirection: direction,
      includeExtras: true,
      includeMultilingual: false,
      includeVariations: true,
      page: page
    ) { result in
      switch result {
      case let .success(value):
        completion(.success((value.data, value.hasMore == true)))
        
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
