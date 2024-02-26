//
//  GameViewController.swift
//  Oracle
//
//  Created by Jun on 25/2/24.
//

import UIKit

final class MyCollectionTableViewController: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
    tabBarItem = UITabBarItem(
      title: "Collection",
      image: UIImage(systemName: "archivebox"),
      selectedImage: UIImage(systemName: "archivebox.fill")
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
