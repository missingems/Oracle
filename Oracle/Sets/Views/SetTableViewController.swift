//
//  SetsTableViewController.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import UIKit

final class SetTableViewController: UITableViewController {
  private let viewModel: SetTableViewModel
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(viewModel: SetTableViewModel) {
    self.viewModel = viewModel
    super.init(style: .plain)
    
    tableView.register(SetTableViewParentCell.self, forCellReuseIdentifier: "\(SetTableViewParentCell.self)")
    tableView.register(SetTableViewChildCell.self, forCellReuseIdentifier: "\(SetTableViewChildCell.self)")
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
    
    viewModel.didUpdate = { [weak self] state in
      DispatchQueue.main.async {
        switch state {
        case .isLoading:
          break
          
        case .shouldReloadData:
          self?.tableView.reloadData()
          
        case .shouldEndRefreshing:
          self?.tableView.refreshControl?.endRefreshing()
          
        case let .shouldDisplayError(error):
          break
        }
      }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = viewModel.configuration.searchBarPlaceholder
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }
}

// MARK: - View Events

extension SetTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.update(.viewDidLoad)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.update(.viewWillAppear)
  }
  
  @objc private func pullToRefreshValueChanged() {
    viewModel.update(.pullToRefreshInvoked)
  }
}

// MARK: - UISearchResultsUpdating

extension SetTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard 
      searchController.isActive,
      let text = searchController.searchBar.text,
      !text.isEmpty 
    else {
      viewModel.update(.searchBarResigned)
      return
    }
    
    viewModel.update(.searchBarTextChanged(text))
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SetTableViewController {
  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    viewModel.displayingDataSource.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let preview = viewModel.displayingDataSource[indexPath.row]
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
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.update(
      .didSelectSet(
        viewModel.displayingDataSource[indexPath.row]
      )
    )
  }
}
