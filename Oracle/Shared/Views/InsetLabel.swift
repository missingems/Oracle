//
//  InsetLabel.swift
//  Oracle
//
//  Created by Jun on 5/3/24.
//

import UIKit

final class InsetLabel: UILabel {
  private let inset: UIEdgeInsets
  
  init(_ inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)) {
    self.inset = inset
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    let width = size.width + inset.left + inset.right
    let height = size.height + inset.top + inset.bottom
    return .init(width: max(width, height), height: height)
  }
}
