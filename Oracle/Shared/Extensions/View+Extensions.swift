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
  
  static func divider() -> UIView {
    let view = UIView()
    view.backgroundColor = .separator
    let containerView = UIView()
    containerView.addSubview(view)
    
    view.widthAnchor == 1 / UIScreen.main.nativeScale
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
  
  func animateRotate(to rotation: Rotation) {
    UIView.animate(withDuration: 0.315, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut) {
      switch rotation {
      case let .degrees(value):
        self.transform = CGAffineTransformMakeRotation(value * Double.pi/180);
        
      case .identity:
        self.transform = .identity
      }
    }
  }
  
  func animateWiggle() {
    UIView.animate(withDuration: 0.315, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
      self.transform = .init(translationX: self.transform.tx - 10, y: self.transform.ty)
    }
    
    UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
      self.transform = .identity
    }
  }
  
  func withDivider() -> Self {
    let divider = UIView.divider()
    addSubview(divider)
    divider.trailingAnchor == trailingAnchor
    divider.verticalAnchors == verticalAnchors
    return self
  }
  
  func wrapped(size: CGSize) -> UIView {
    let view = UIView()
    view.addSubview(self)
    self.horizontalAnchors == view.horizontalAnchors
    self.centerYAnchor == view.centerYAnchor
    self.sizeAnchors == size
    return view
  }
  
  enum Rotation {
    case degrees(CGFloat)
    case identity
  }
}

extension UIStackView {
  func withVerticalAxis() -> Self {
    addArrangedSubview(UIView())
    axis = .vertical
    preservesSuperviewLayoutMargins = true
    return self
  }
}
