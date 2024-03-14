//
//  SetDetailNetworkService.swift
//  Oracle
//
//  Created by Jun on 14/3/24.
//

import Foundation
import ScryfallKit

protocol SetDetailNetworkService {
  func fetchSetDetail(page: Int, sort: SetDetailSortMode)
}

extension ScryfallClient: SetDetailNetworkService {
  func fetchSetDetail(page: Int, sort: SetDetailSortMode) {
    //
  }
}

enum SetDetailSortMode {
  case name
  case price
  case color
  case rarity
  case released
}
