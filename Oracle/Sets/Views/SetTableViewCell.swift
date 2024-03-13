import Anchorage
import UIKit
import SDWebImage

final class SetTableViewCell: SinkableTableViewCell {
  private(set) lazy var subContentView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 9
    view.layer.cornerCurve = .continuous
    return view
  }()
  
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
  
  private lazy var childIndicatorView = {
    let containerView = UIView()
    let iconImageView = UIImageView(image: UIImage(systemName: "arrow.turn.down.right"))
    containerView.addSubview(iconImageView)
    iconImageView.sizeAnchors == CGSize(width: 20, height: 20)
    iconImageView.centerAnchors == containerView.centerAnchors
    iconImageView.tintColor = .tertiaryLabel
    containerView.widthAnchor == 30
    return containerView
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
    iconImageView.tintColor = .accent
    
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
    
    let chevronImageView =  UIImageView(image: UIImage(systemName: "chevron.right"))
    let chevronContainerView = UIView()
    chevronContainerView.addSubview(chevronImageView)
    chevronImageView.sizeAnchors == CGSize(width: 20, height: 20)
    chevronImageView.contentMode = .scaleAspectFit
    chevronImageView.tintColor = .tertiaryLabel
    chevronImageView.horizontalAnchors == chevronContainerView.horizontalAnchors
    chevronImageView.centerYAnchor == chevronContainerView.centerYAnchor
    
    let stackView = UIStackView(arrangedSubviews: [
      childIndicatorView,
      containerView,
      verticalStackView,
      UIView(),
      chevronContainerView,
    ])
    
    stackView.spacing = 13
    stackView.axis = .horizontal
    
    subContentView.addSubview(stackView)
    stackView.edgeAnchors == subContentView.edgeAnchors + UIEdgeInsets(top: 13, left: 13, bottom: 15, right: 13)
    
    contentView.addSubview(subContentView)
    subContentView.horizontalAnchors == contentView.layoutMarginsGuide.horizontalAnchors - 8
    subContentView.verticalAnchors == contentView.verticalAnchors
  }
  
  func configure(
    setID: String,
    title: String,
    iconURI: String,
    numberOfCards: Int,
    index: Int,
    isParentSet: Bool
  ) {
    titleLabel.text = title
    setIdLabel.text = setID.uppercased()
    subtitleLabel.text = String(localized: "\(numberOfCards) Cards")
    
    iconImageView.sd_setImage(
      with: URL(string: iconURI), 
      placeholderImage: nil,
      options: [.refreshCached],
      context: [
        .imageThumbnailPixelSize : CGSize(width: 30 * UIScreen.main.nativeScale, height: 30 * UIScreen.main.nativeScale),
        .imagePreserveAspectRatio : true
      ], 
      progress: nil,
      completed: { [weak self] image, error, cache, url in
        self?.iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
      }
    )
    
    if index % 2 == 0 {
      subContentView.backgroundColor = .quaternarySystemFill
    } else {
      subContentView.backgroundColor = .clear
    }
    
    childIndicatorView.isHidden = !isParentSet
  }
}
