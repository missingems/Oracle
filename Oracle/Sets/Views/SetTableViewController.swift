//
//  SetsTableViewController.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import Anchorage
import UIKit

final class SetTableViewController: UITableViewController {
  private let viewModel: SetTableViewModel
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(viewModel: SetTableViewModel) {
    self.viewModel = viewModel
    super.init(style: .plain)
    
    viewModel.didUpdate = { [weak self] message in
      guard let self else { return }
      
      switch message {
      case let .shouldDisplayError(error):
        self.tableView.backgroundView = ErrorView(
          title: viewModel.configuration.errorTitle, 
          subtitle: error.localizedDescription
        )
        self.tableView.refreshControl?.endRefreshing()
        
      case .shouldDisplayData:
        self.tableView.backgroundView = nil
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
      }
    }
    
    defer {
      tableView.register(SetTableViewParentCell.self, forCellReuseIdentifier: "\(SetTableViewParentCell.self)")
      tableView.register(SetTableViewChildCell.self, forCellReuseIdentifier: "\(SetTableViewChildCell.self)")
      tableView.register(CardSearchTableViewCell.self, forCellReuseIdentifier: "\(CardSearchTableViewCell.self)")
      tableView.separatorStyle = .none
      tableView.backgroundView = LoadingView()
      
      navigationItem.title = viewModel.configuration.title
      
      tabBarItem = UITabBarItem(
        title: viewModel.configuration.title,
        image: UIImage(systemName: viewModel.configuration.tabBarDeselectedSystemImageName),
        selectedImage: UIImage(systemName: viewModel.configuration.tabBarSelectedSystemImageName)
      )
      
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(pullToRefreshValueChanged), for: .valueChanged)
      tableView.refreshControl = refreshControl
      
      let searchController = UISearchController(searchResultsController: nil)
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = viewModel.configuration.searchBarPlaceholder
      searchController.searchResultsUpdater = self
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
      definesPresentationContext = true
    }
  }
}

// MARK: - View Events

extension SetTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.update(.viewDidLoad)
  }
  
  @objc private func pullToRefreshValueChanged() {
    viewModel.update(.pullToRefreshValueChanged)
  }
}

// MARK: - UISearchResultsUpdating

extension SetTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard searchController.isActive, let text = searchController.searchBar.text else {
      viewModel.update(.searchBarResigned)
      return
    }
    
    viewModel.update(.searchBarTextChanged(text))
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SetTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.displayingDataSource.count
  }
  
  override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = viewModel.displayingDataSource[section].numberOfRows
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let preview = viewModel.displayingDataSource[indexPath.section]
    
    switch preview {
    case let .sets(values):
      let preview = values[indexPath.row]
      let cell: SetTableViewCell?
      
      if preview.parentSetCode == nil || navigationItem.searchController?.isActive == true {
        cell = tableView.dequeueReusableCell(withIdentifier: "\(SetTableViewParentCell.self)", for: indexPath) as? SetTableViewParentCell
      } else {
        cell = tableView.dequeueReusableCell(withIdentifier: "\(SetTableViewChildCell.self)", for: indexPath) as? SetTableViewChildCell
      }
      
      cell?.configure(
        setID: preview.code,
        title: preview.name,
        iconURI: preview.iconSvgUri,
        numberOfCards: preview.cardCount,
        index: indexPath.row,
        query: navigationItem.searchController?.searchBar.text
      )
      
      guard let cell = cell as? UITableViewCell else {
        fatalError()
      }
      
      cell.selectionStyle = .none
      
      return cell
      
    case let .cards(cards):
      let card = cards[indexPath.row]
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CardSearchTableViewCell.self)", for: indexPath) as? CardSearchTableViewCell else {
        fatalError()
      }
      
      cell.configure(name: card, query: navigationItem.searchController?.searchBar.text)
      cell.selectionStyle = .none
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch viewModel.displayingDataSource[indexPath.section] {
    case let .cards(value):
      viewModel.update(.didSelectCardName(value[indexPath.row]))
      
    case let .sets(value):
      viewModel.update(.didSelectSet(value[indexPath.row]))
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard navigationItem.searchController?.isActive == true else {
      return nil
    }
    
    return viewModel.displayingDataSource[section].title
  }
}
