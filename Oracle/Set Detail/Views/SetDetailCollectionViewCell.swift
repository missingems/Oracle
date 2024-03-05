import Anchorage
import UIKit
import ScryfallKit

final class SetDetailCollectionViewCell: SinkableCollectionViewCell {
  private let imageView = CardView()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    contentView.addSubview(imageView)
    imageView.edgeAnchors == contentView.edgeAnchors
  }
  
  init(type: CardView.Size) {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(_ card: Card, size: CardView.Size = .regular) {
    imageView.configure(card, imageType: .normal, size: size)
  }
  
  func setPlaceholder() {
    imageView.setPlaceholder(size: .regular)
  }
}
