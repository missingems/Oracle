//
//  AmbientCollectionView.swift
//  Oracle
//
//  Created by Jun on 3/3/24.
//

import Anchorage
import UIKit

final class Ambient {
  struct Configuration {
    let titleFont: UIFont?
    let title: String?
    let flowLayout: UICollectionViewFlowLayout
    let height: CGFloat?
    let width: CGFloat?
    
    init(
      titleFont: UIFont? = nil,
      title: String? = nil,
      flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(),
      height: CGFloat? = nil,
      width: CGFloat? = nil
    ) {
      self.titleFont = titleFont
      self.title = title
      self.flowLayout = flowLayout
      self.height = height
      self.width = width
    }
  }
  
  private let configuration: Configuration
  private let titleLabel: UILabel?
  private let backgroundCollectionView: UICollectionView
  let collectionView: UICollectionView

  init<Host: UICollectionViewDelegate & UICollectionViewDataSource> (
    host: Host,
    configuration: Configuration
  ) {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: configuration.flowLayout)
    backgroundCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configuration.flowLayout)
    collectionView.delegate = host
    backgroundCollectionView.delegate = host
    collectionView.dataSource = host
    backgroundCollectionView.dataSource = host
    
    if let title = configuration.title, let font = configuration.titleFont {
      titleLabel = UILabel(frame: .zero)
      titleLabel?.text = title
      titleLabel?.font = font
      titleLabel?.numberOfLines = 0
    } else {
      titleLabel = nil
    }
    
    self.configuration = configuration
    collectionView.clipsToBounds = false
    backgroundCollectionView.clipsToBounds = false
    collectionView.showsHorizontalScrollIndicator = false
  }
  
  func embed(in view: UIView, cells: AnyClass...) {
    view.addSubview(backgroundCollectionView)
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    view.addSubview(visualEffectView)
    visualEffectView.edgeAnchors == view.edgeAnchors
    
    visualEffectView.contentView.addSubview(collectionView)
    
    if let titleLabel {
      visualEffectView.contentView.addSubview(titleLabel)
      titleLabel.topAnchor == visualEffectView.contentView.topAnchor + 13.0
      titleLabel.horizontalAnchors == visualEffectView.contentView.layoutMarginsGuide.horizontalAnchors
      collectionView.topAnchor == titleLabel.bottomAnchor + 13.0
      collectionView.horizontalAnchors == visualEffectView.contentView.horizontalAnchors
      collectionView.bottomAnchor == visualEffectView.contentView.bottomAnchor - 13.0
    } else {
      collectionView.edgeAnchors == visualEffectView.contentView.edgeAnchors
    }
    
    if let height = configuration.height {
      collectionView.heightAnchor == height
    }
    
    collectionView.backgroundColor = .clear
    
    backgroundCollectionView.edgeAnchors == collectionView.edgeAnchors
    backgroundCollectionView.backgroundColor = .clear
    backgroundCollectionView.isScrollEnabled = false
    
    cells.forEach {
      collectionView.register($0, forCellWithReuseIdentifier: "\($0)")
      backgroundCollectionView.register($0, forCellWithReuseIdentifier: "\($0)")
    }
    
    visualEffectView.contentView.preservesSuperviewLayoutMargins = true
    visualEffectView.preservesSuperviewLayoutMargins = true
  }
  
  func reloadData() {
    collectionView.reloadData()
    backgroundCollectionView.reloadData()
  }
  
  func syncScroll(_ collectionView: UICollectionView) {
    if collectionView === self.collectionView {
      backgroundCollectionView.contentOffset = collectionView.contentOffset
    }
  }
  
  func syncHighlightedCell(at indexPath: IndexPath, isHighlighted: Bool) {
    backgroundCollectionView.cellForItem(at: indexPath)?.isHighlighted = isHighlighted
  }
}
