import Anchorage
import UIKit
import ScryfallKit

final class SetDetailCollectionViewCell: SinkableCollectionViewCell {
  let imageView = CardView(type: .regular)
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    contentView.addSubview(imageView)
    imageView.edgeAnchors == contentView.edgeAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(_ card: Card) {
    imageView.configure(card, imageType: .normal)
  }
  
  func setPlaceholder() {
    imageView.setPlaceholder()
  }
}
