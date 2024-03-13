//
//  SetsTableViewController.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import UIKit

final class SetsTableViewController: UITableViewController {
  private let viewModel: SetsTableViewModel
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(client: any SetsTableViewNetworkService) {
    self.viewModel = SetsTableViewModel(client: client)
    super.init(style: .plain)
    
    tableView.register(SetsTableViewCell.self, forCellReuseIdentifier: "SetsTableViewCell")
    tableView.separatorStyle = .none
    
    navigationItem.title = viewModel.staticConfiguration.title
    
    tabBarItem = UITabBarItem(
      title: viewModel.staticConfiguration.title,
      image: UIImage(systemName: viewModel.staticConfiguration.tabBarDeselectedSystemImageName),
      selectedImage: UIImage(systemName: viewModel.staticConfiguration.tabBarSelectedSystemImageName)
    )
    
    viewModel.didUpdate = { [weak self] state in
      DispatchQueue.main.async {
        switch state {
        case .isLoading:
          break
          
        case .shouldReloadData:
          self?.tableView.reloadData()
        }
      }
    }
  }
}

// MARK: - View Events

extension SetsTableViewController {
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.fetchSets()
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SetsTableViewController {
  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    viewModel.dataSource.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetsTableViewCell", for: indexPath) as? SetsTableViewCell else {
      fatalError("\(SetsTableViewCell.self) can't be found")
    }
    
    let preview = viewModel.dataSource[indexPath.row]
    cell.selectionStyle = .none
    
    cell.configure(
      setID: preview.code,
      title: preview.name,
      iconURI: preview.iconURI,
      numberOfCards: preview.numberOfCards,
      index: indexPath.row,
      isParentSet: preview.parentCode != nil
    )
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let set = viewModel.dataSource[indexPath.row]
//    let detail = SetDetailCollectionViewController(SetDetailCollectionViewModel(set: set))
//    show(detail, sender: cell)
  }
}
