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
    
    viewModel.didUpdate = { [weak self] state in
      guard let self else { return }
      
      switch state {
      case .isLoading:
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        self.tableView.backgroundView = loadingIndicator
        
      case .shouldReloadData:
        if viewModel.displayingDataSource.isEmpty == false {
          self.tableView.backgroundView = nil
        }
        
        self.tableView.reloadData()
        
      case .shouldEndRefreshing:
        self.tableView.refreshControl?.endRefreshing()
        
      case let .shouldDisplayError(error):
        self.tableView.backgroundView = ErrorView(
          title: viewModel.configuration.errorTitle, 
          subtitle: error.localizedDescription
        )
      }
    }
    
    defer {
      tableView.register(SetTableViewParentCell.self, forCellReuseIdentifier: "\(SetTableViewParentCell.self)")
      tableView.register(SetTableViewChildCell.self, forCellReuseIdentifier: "\(SetTableViewChildCell.self)")
      tableView.register(CardSearchTableViewCell.self, forCellReuseIdentifier: "\(CardSearchTableViewCell.self)")
      tableView.separatorStyle = .none
      
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
    viewModel.update(.pullToRefreshInvoked)
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
      
      if preview.parentCode == nil || navigationItem.searchController?.isActive == true {
        cell = tableView.dequeueReusableCell(withIdentifier: "\(SetTableViewParentCell.self)", for: indexPath) as? SetTableViewParentCell
      } else {
        cell = tableView.dequeueReusableCell(withIdentifier: "\(SetTableViewChildCell.self)", for: indexPath) as? SetTableViewChildCell
      }
      
      cell?.configure(
        setID: preview.code,
        title: preview.name,
        iconURI: preview.iconURI,
        numberOfCards: preview.numberOfCards,
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
      let card = value[indexPath.row]
      viewModel.update(.didSelectCard(name: card))
      
    case let .sets(value):
      let set = value[indexPath.row]
      viewModel.update(.didSelectSet(set))
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard navigationItem.searchController?.isActive == true else {
      return nil
    }
    
    return viewModel.displayingDataSource[section].title
  }
}
