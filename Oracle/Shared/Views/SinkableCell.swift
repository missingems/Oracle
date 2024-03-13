//
//  SinkableCell.swift
//  Oracle
//
//  Created by Jun on 3/3/24.
//

import UIKit

class SinkableCollectionViewCell: UICollectionViewCell {
  var onHighlighted: ((Bool) -> ())?
  
  override var isHighlighted: Bool {
    didSet {
      onHighlighted?(isHighlighted)
      animate(isHighlighted: isHighlighted)
    }
  }
  
  func animate(isHighlighted: Bool) {
    UIView.animate(
      springDuration: 0.314,
      bounce: 0.5,
      delay: isHighlighted ? 0 : 0.1,
      options: .curveEaseInOut
    ) {
      if isHighlighted {
        contentView.subviews.first?.alpha = 0.382
        contentView.subviews.first?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
      } else {
        contentView.subviews.first?.alpha = 1
        contentView.subviews.first?.transform = .identity
      }
    }
  }
}

class SinkableTableViewCell: UITableViewCell {
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    animate(isHighlighted: highlighted)
  }
  
  func animate(isHighlighted: Bool) {
    UIView.animate(
      springDuration: 0.314,
      bounce: 0.5,
      delay: isHighlighted ? 0 : 0.1,
      options: .curveEaseInOut
    ) {
      if isHighlighted {
        contentView.subviews.first?.alpha = 0.382
        contentView.subviews.first?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
      } else {
        contentView.subviews.first?.alpha = 1
        contentView.subviews.first?.transform = .identity
      }
    }
  }
}
