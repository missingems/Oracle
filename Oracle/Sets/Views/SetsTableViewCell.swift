import Anchorage
import UIKit
import SDWebImage

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

final class SetsTableViewCell: UITableViewCell {
  private lazy var setIdLabel = {
    let label = InsetLabel()
    let caption = UIFont.preferredFont(forTextStyle: .caption1)
    label.font = .monospacedSystemFont(ofSize: caption.pointSize, weight: .regular)
    label.numberOfLines = 0
    label.backgroundColor = .systemFill
    label.textColor = .label
    label.setContentHuggingPriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.layer.cornerRadius = 3
    label.layer.cornerCurve = .continuous
    label.textAlignment = .center
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var titleLabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    label.textColor = .label
    label.setContentHuggingPriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()
  
  private lazy var subtitleLabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    label.numberOfLines = 0
    label.textColor = .secondaryLabel
    label.setContentHuggingPriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()
  
  private lazy var iconImageView = UIImageView()
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let containerView = UIView()
    containerView.addSubview(iconImageView)
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.sizeAnchors == CGSize(width: 30, height: 30)
    iconImageView.horizontalAnchors == containerView.horizontalAnchors
    iconImageView.centerYAnchor == containerView.centerYAnchor
    iconImageView.tintColor = .label
    
    contentView.addSubview(titleLabel)
    
    let captionView = UIStackView(arrangedSubviews: [
      setIdLabel,
      subtitleLabel,
      UIView()
    ])
    captionView.spacing = 5
    
    let verticalStackView = UIStackView(arrangedSubviews: [
      titleLabel,
      captionView
    ])
    verticalStackView.spacing = 5
    verticalStackView.axis = .vertical
    
    let stackView = UIStackView(arrangedSubviews: [
      containerView,
      verticalStackView
    ])
    
    stackView.spacing = 13
    stackView.axis = .horizontal
    contentView.addSubview(stackView)
    
    stackView.horizontalAnchors == contentView.layoutMarginsGuide.horizontalAnchors
    stackView.verticalAnchors == contentView.verticalAnchors + 13
  }
  
  func configure(setID: String, title: String, iconURI: String, numberOfCards: Int) {
    titleLabel.text = title
    setIdLabel.text = setID.uppercased()
    subtitleLabel.text = String(localized: "\(numberOfCards) cards")
    
    iconImageView.sd_setImage(
      with: URL(string: iconURI), 
      placeholderImage: nil,
      options: [],
      context: [
        .imageThumbnailPixelSize : CGSize(width: 30 * UIScreen.main.nativeScale, height: 30 * UIScreen.main.nativeScale),
        .imagePreserveAspectRatio : true
      ], 
      progress: nil,
      completed: { [weak self] image, error, cache, url in
        self?.iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
      }
    )
  }
}
