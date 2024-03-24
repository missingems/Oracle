import SwiftUI

public struct PillText: View {
  public let label: String
  
  public init(_ label: String) {
    self.label = label
  }
  
  public var body: some View {
    Text(label)
      .multilineTextAlignment(.center)
      .padding(.horizontal, Spacing.small.rawValue)
      .background {
        Color(uiColor: .systemFill)
      }
      .clipShape(.buttonBorder)
  }
}
