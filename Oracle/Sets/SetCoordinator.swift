//
//  SetCoordinator.swift
//  Oracle
//
//  Created by Jun on 14/3/24.
//

import UIKit
import ScryfallKit
import SafariServices

final class SetCoordinator {
  enum Destination {
    case showCard(Card, set: (any GameSet)?)
    case showCardResult(cardName: String)
    case showSetDetail(set: any GameSet)
    case showSets
    case showRulings(card: Card)
    case showURL(url: URL?)
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
  
  func present(destination: Destination, shouldEmbedInNavigationController: Bool) {
    let viewController: UIViewController
    
    if shouldEmbedInNavigationController {
      viewController = UINavigationController(rootViewController: self.viewController(for: destination))
    } else {
      viewController = self.viewController(for: destination)
    }
    
    navigationController.present(viewController, animated: true)
  }
  
  private func viewController(for destination: Destination) -> UIViewController {
    switch destination {
    case let .showCard(card, set):
      return CardDetailViewController(viewModel: CardDetailViewModel(card: card, set: set, coordinator: self))
      
    case let .showCardResult(cardName):
      return SetDetailCollectionViewController(SetDetailCollectionViewModel(query: .card(cardName), client: ScryfallClient(), coordinator: self))
      
    case let .showRulings(card):
      return RulingTableViewController(viewModel: RulingTableViewModel(card: card))
      
    case let .showSetDetail(set):
      return SetDetailCollectionViewController(SetDetailCollectionViewModel(query: .set(set), client: ScryfallClient(), coordinator: self))
      
    case .showSets:
      return SetTableViewController(viewModel: SetTableViewModel(client: ScryfallClient(), coordinator: self))
      
    case let .showURL(value):
      guard let value else {
        fatalError("URL cannot be nil")
      }
      
      return SFSafariViewController(url: value)
    }
  }
  
  func makeNewServiceClient() -> ScryfallClient {
    ScryfallClient()
  }
}
