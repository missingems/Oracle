//
//  SetCoordinator.swift
//  Oracle
//
//  Created by Jun on 14/3/24.
//

import UIKit
import ScryfallKit

final class SetCoordinator {
  enum Destination {
    case showCard(Card)
    case showCardResult(cardName: String)
    case showSetDetail(set: any GameSet)
    case showSets
    case showRulings(card: Card)
  }
  
  private(set) lazy var rootViewController = viewController(for: root)
  private(set) lazy var navigationController = UINavigationController(rootViewController: rootViewController)
  private let networkServiceClient = ScryfallClient()
  private let root: Destination
  
  init(root: Destination) {
    self.root = root
    navigationController.navigationItem.largeTitleDisplayMode = .always
    rootViewController.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func show(destination: Destination) {
    navigationController.pushViewController(viewController(for: destination), animated: true)
  }
  
  func present(destination: Destination) {
    navigationController.present(UINavigationController(rootViewController: viewController(for: destination)), animated: true)
  }
  
  private func viewController(for destination: Destination) -> UIViewController {
    switch destination {
    case let .showCard(card):
      return CardDetailViewController(viewModel: CardDetailViewModel(card: card, coordinator: self))
      
    case let .showCardResult(cardName):
      return SetDetailCollectionViewController(SetDetailCollectionViewModel(query: .card(cardName), client: ScryfallClient(), coordinator: self))
      
    case let .showRulings(card):
      return RulingTableViewController(viewModel: RulingTableViewModel(card: card))
      
    case let .showSetDetail(set):
      return SetDetailCollectionViewController(SetDetailCollectionViewModel(query: .set(set), client: ScryfallClient(), coordinator: self))
      
    case .showSets:
      return SetTableViewController(viewModel: SetTableViewModel(client: ScryfallClient(), coordinator: self))
    }
  }
  
  func makeNewServiceClient() -> ScryfallClient {
    ScryfallClient()
  }
}
