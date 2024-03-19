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
    
    viewModel.didUpdateRulings = { [weak self] hasResults in
      self?.tableView.reloadData()
      if hasResults {
        self?.tableView.backgroundView = nil
      } else {
        self?.tableView.backgroundView = ErrorView(title: "No Results", subtitle: nil)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundView = LoadingView()
    navigationItem.title = viewModel.title
    viewModel.fetchRulings()
    
    let titleLabel = {
      let label = UILabel()
      label.font = .preferredFont(forTextStyle: .headline)
      label.textAlignment = .center
      return label
    }()
    
    let subtitleLabel = {
      let label = UILabel()
      label.font = .preferredFont(forTextStyle: .caption1)
      label.textAlignment = .center
      label.textColor = .secondaryLabel
      return label
    }()
    
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      subtitleLabel
    ])
    stackView.axis = .vertical
    navigationItem.titleView = stackView
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      systemItem: .done,
      primaryAction: UIAction(
        handler: { _ in
          self.dismiss(animated: true)
        }
      )
    )
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.rulings.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "RulingTableViewCell")
    cell.textLabel?.text = viewModel.rulings[indexPath.section].comment
    cell.textLabel?.numberOfLines = 0
    cell.selectionStyle = .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    viewModel.rulings[section].publishedAt
  }
}

final class RulingTableViewModel {
  private let client: ScryfallClient
  private let card: Card
  var rulings: [Card.Ruling] = []
  var didUpdateRulings: ((Bool) -> ())?
  let title: String
  let subtitle: String
  
  init(card: Card) {
    client = ScryfallClient(networkLogLevel: .minimal)
    title = String(localized: "Rulings")
    subtitle = card.name
    self.card = card
  }
  
  func fetchRulings() {
    client.getRulings(.scryfallID(id: card.id.uuidString)) { result in
      DispatchQueue.main.async { [weak self] in
        switch result {
        case let .success(value):
          self?.rulings = value.data.reversed()
          self?.didUpdateRulings?(!value.data.isEmpty)
          
        case .failure:
          self?.didUpdateRulings?(false)
        }
      }
    }
  }
}
