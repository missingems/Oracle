//
//  RulingTableViewController.swift
//  Oracle
//
//  Created by Jun on 19/3/24.
//

import UIKit
import ScryfallKit

final class RulingTableViewController: UITableViewController {
  private let viewModel: RulingTableViewModel
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  init(viewModel: RulingTableViewModel) {
    self.viewModel = viewModel
    super.init(style: .plain)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.fetchRulings()
  }
}

final class RulingTableViewModel {
  private let client: ScryfallClient
  private let card: Card
  
  init(card: Card) {
    client = ScryfallClient(networkLogLevel: .minimal)
    self.card = card
  }
  
  func fetchRulings() {
    client.getRulings(.scryfallID(id: card.id.uuidString)) { result in
      
    }
  }
}
