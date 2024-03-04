//
//  SetsTableViewController.swift
//  Oracle
//
//  Created by Jun on 2/14/24.
//

import UIKit

final class SetsTableViewController: UITableViewController {
  private var viewModel = SetsTableViewModel(state: .loading)
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init() {
    super.init(style: .plain)
    setupViews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Task { [weak self] in
      guard let self else {
        return
      }
      
      switch await self.viewModel.fetchSets() {
      case .loading:
        break
        
      case .data:
        tableView.reloadData()
      }
    }
  }
  
  private func setupViews() {
    tableView.register(SetsTableViewCell.self, forCellReuseIdentifier: "SetsTableViewCell")
    tableView.separatorStyle = .none
    navigationItem.title = viewModel.state.title
    tabBarItem = UITabBarItem(
      title: viewModel.state.title,
      image: UIImage(systemName: "book.pages"),
      selectedImage: UIImage(systemName: "book.pages.fill")
    )
  }
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    viewModel.state.sets.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetsTableViewCell", for: indexPath) as? SetsTableViewCell else {
      fatalError("\(SetsTableViewCell.self) can't be found")
    }
    
    let preview = viewModel.state.sets[indexPath.row]
    cell.selectionStyle = .none
    
    cell.configure(
      setID: preview.code,
      title: preview.name,
      iconURI: preview.iconSvgUri,
      numberOfCards: preview.cardCount,
      index: indexPath.row,
      isParentSet: preview.parentSetCode != nil
    )
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let set = viewModel.state.sets[indexPath.row]
    let detail = SetDetailCollectionViewController(SetDetailCollectionViewModel(set: set))
    let cell = tableView.cellForRow(at: indexPath)
    show(detail, sender: cell)
  }
}
