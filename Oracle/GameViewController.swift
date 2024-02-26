//
//  GameViewController.swift
//  Oracle
//
//  Created by Jun on 25/2/24.
//

import UIKit

final class GameViewController: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
    tabBarItem = UITabBarItem(
      title: "Game",
      image: UIImage(systemName: "dice"),
      selectedImage: UIImage(systemName: "dice.fill")
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
