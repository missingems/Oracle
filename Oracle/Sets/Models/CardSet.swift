//
//  CardSet.swift
//  Oracle
//
//  Created by Jun on 13/3/24.
//

import Foundation
import ScryfallKit

protocol CardSet: Equatable {
  var name: String { get }
  var code: String { get }
  var iconURI: String { get }
  var numberOfCards: Int { get }
  var parentCode: String? { get }
}

extension MTGSet: CardSet {
  var iconURI: String {
    iconSvgUri
  }
  
  var numberOfCards: Int {
    cardCount
  }
  
  var parentCode: String? {
    parentSetCode
  }
}
