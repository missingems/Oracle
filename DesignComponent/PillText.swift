import SwiftUI

public struct PillText: View {
  public let label: String
  
  public init(_ label: String) {
    self.label = label
  }
  
  public var body: some View {
    Text(label)
      .multilineTextAlignment(.center)
      .padding(.horizontal, 3.0)
      .background {
        Color(.systemFill)
      }
      .clipShape(.buttonBorder)
  }
}
