import Anchorage
import UIKit
import SwiftUI

final class HostingView<V: View>: UIView {
  var rootView: V
  
  init(_ view: V, in viewController: UIViewController) {
    self.rootView = view
    super.init(frame: .zero)
    
    let hostingController = UIHostingController(rootView: rootView)
    hostingController.didMove(toParent: viewController)
    
    guard let hostingControllerView = hostingController.view else {
      return
    }
    
    addSubview(hostingControllerView)
    preservesSuperviewLayoutMargins = true
    hostingControllerView.preservesSuperviewLayoutMargins = true
    hostingControllerView.edgeAnchors == edgeAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIView {
  static func separator(with insets: UIEdgeInsets = .zero, fullWidth: Bool = false) -> UIView {
    let view = UIView()
    view.backgroundColor = .separator
    let containerView = UIView()
    containerView.addSubview(view)
    
    if !fullWidth {
      view.leadingAnchor == containerView.layoutMarginsGuide.leadingAnchor + insets.left
      view.trailingAnchor == containerView.trailingAnchor - insets.right
    } else {
      view.leadingAnchor == containerView.leadingAnchor
      view.trailingAnchor == containerView.trailingAnchor
    }
    
    containerView.preservesSuperviewLayoutMargins = true
    view.heightAnchor == 1 / UIScreen.main.nativeScale
    view.verticalAnchors == containerView.verticalAnchors
    
    return containerView
  }
}

extension UIView {
  func animateFlip(options: UIView.AnimationOptions) {
    UIView.transition(
      with: self,
      duration: 0.315,
      options: options
    ) {}
  }
}
