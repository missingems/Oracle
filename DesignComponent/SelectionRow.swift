import SwiftUI

public struct SelectionRow: View {
  public enum Icon: Equatable {
    case custom(name: String?)
    case system(name: String?)
  }
  
  let icon: Icon
  let title: String
  let detail: String
  
  public var body: some View {
    HStack {
      let pointSize = UIFont.preferredFont(forTextStyle: .headline).pointSize
      
      if case let .custom(name) = icon, let name {
        Image(name)
          .renderingMode(.template)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: pointSize, height: pointSize)
      } else if case let .system(name) = icon, let name {
        Image(systemName: name)
          .renderingMode(.template)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: pointSize, height: pointSize)
      }
      
      Text(title).font(.headline).tint(.primary)
    }
    
    Spacer()
    
    HStack {
      Text(detail).font(.body).tint(.secondary)
      Image(systemName: "chevron.right")
        .tint(.tertiaryLabel)
        .fontWeight(.medium)
        .imageScale(.small)
    }
  }
  
  public init(icon: Icon, title: String, detail: String) {
    self.icon = icon
    self.title = title
    self.detail = detail
  }
}
