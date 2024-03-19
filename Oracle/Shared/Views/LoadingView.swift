//
//  LoadingView.swift
//  Oracle
//
//  Created by Jun on 19/3/24.
//

import Anchorage
import UIKit

final class LoadingView: UIView {
  init() {
    super.init(frame: .zero)
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.startAnimating()
    addSubview(activityIndicator)
    activityIndicator.centerAnchors == centerAnchors
    activityIndicator.horizontalAnchors <= horizontalAnchors
    activityIndicator.verticalAnchors >= verticalAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
