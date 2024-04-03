import SwiftUI

public struct PillText: View {
  public let label: String
  private let insets: EdgeInsets
  
  public init(_ label: String, insets: EdgeInsets = EdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3)) {
    self.label = label
    self.insets = insets
  }
  
  public var body: some View {
    Text(label)
      .multilineTextAlignment(.center)
      .padding(insets)
      .background {
        Color(.systemFill)
      }
      .clipShape(.buttonBorder)
  }
}
