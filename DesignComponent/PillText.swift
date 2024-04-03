import SwiftUI

public struct PillText: View {
  public let label: String
  
  public init(_ label: String) {
    self.label = label
  }
  
  public var body: some View {
    Text(label)
      .multilineTextAlignment(.center)
      .padding(EdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3))
      .background {
        Color(.systemFill)
      }
      .clipShape(.buttonBorder)
  }
}
