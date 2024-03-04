import Anchorage
import UIKit
import ScryfallKit

final class SetDetailCollectionViewCell: SinkableCollectionViewCell {
  private(set) lazy var imageView = CardView()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    contentView.addSubview(imageView)
    imageView.edgeAnchors == contentView.edgeAnchors
    
    imageView.horizontalAnchors == contentView.horizontalAnchors
    imageView.heightAnchor == contentView.widthAnchor * 936 / 672 ~ .required
    imageView.verticalAnchors == contentView.verticalAnchors ~ .high
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(_ card: Card) {
    imageView.configure(card, imageType: .normal)
  }
}
