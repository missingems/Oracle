import UIKit
import CoreMotion

class FoilEffectView: UIView {
  private var gradientLayer: CAGradientLayer!
  private let motionManager = CMMotionManager()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupFoilEffect()
    startMotionUpdates()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  private func setupFoilEffect() {
    gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.bounds
    gradientLayer.colors = [
      UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.green.cgColor,
    ]
    layer.addSublayer(gradientLayer)
  }
  
  func startMotionUpdates() {
    if motionManager.isAccelerometerAvailable {
      motionManager.accelerometerUpdateInterval = 0.1
      motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
        guard let strongSelf = self, let accelerometerData = data else { return }
        
        let x = CGFloat(accelerometerData.acceleration.x)
        let y = CGFloat(accelerometerData.acceleration.y)
        
        strongSelf.updateGradientLayer(x: x, y: y)
      }
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }
  
  private func updateGradientLayer(x: CGFloat, y: CGFloat) {
    // Base start and end points for the gradient
    let baseStartPoint = CGPoint(x: 0.5, y: 0)
    let baseEndPoint = CGPoint(x: 0.5, y: 1)
    
    // Sensitivity factor for accelerometer influence
    let sensitivity: CGFloat = 2
    
    // Calculate adjusted start and end points
    let adjustedStartX = baseStartPoint.x + x * sensitivity
    let adjustedStartY = baseStartPoint.y + y * sensitivity
    let adjustedEndX = baseEndPoint.x - x * sensitivity
    let adjustedEndY = baseEndPoint.y - y * sensitivity
    
    // Clamp the values to the range [0, 1] to ensure they are valid
    gradientLayer.startPoint = CGPoint(x: min(max(adjustedStartX, 0), 1), y: min(max(adjustedStartY, 0), 1))
    gradientLayer.endPoint = CGPoint(x: min(max(adjustedEndX, 0), 1), y: min(max(adjustedEndY, 0), 1))
  }
  
  deinit {
    motionManager.stopAccelerometerUpdates()
  }
}

// Helper extension to clamp CGFloat values
extension CGFloat {
  func clamped(to limits: ClosedRange<CGFloat>) -> CGFloat {
    let max = CGFloat.maximum(self, limits.lowerBound)
    
    return CGFloat.minimum(max, limits.upperBound)
  }
}
