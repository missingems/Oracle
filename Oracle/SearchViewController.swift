//
//  GameViewController.swift
//  Oracle
//
//  Created by Jun on 25/2/24.
//

import UIKit

final class SearchViewController: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
    tabBarItem = UITabBarItem(
      title: "Search",
      image: UIImage(systemName: "magnifyingglass"),
      selectedImage: UIImage(systemName: "magnifyingglass")
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
