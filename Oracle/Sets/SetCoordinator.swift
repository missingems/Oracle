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
    case showSetDetail(set: any GameSet)
    case showSets
  }
  
  private(set) lazy var navigationController = UINavigationController(rootViewController: viewController(for: root))
  private let networkServiceClient = ScryfallClient()
  private let root: Destination
  
  init(root: Destination) {
    self.root = root
  }
  
  func show(destination: Destination) {
    navigationController.pushViewController(viewController(for: destination), animated: true)
  }
  
  private func viewController(for destination: Destination) -> UIViewController {
    switch destination {
    case let .showSetDetail(set):
      return SetDetailCollectionViewController(SetDetailCollectionViewModel(set: set, client: ScryfallClient()))
      
    case .showSets:
      return SetTableViewController(viewModel: SetTableViewModel(client: ScryfallClient(), coordinator: self))
    }
  }
}
