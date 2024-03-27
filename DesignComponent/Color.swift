import SwiftUI

public extension Color {
  static var quaternarySystemFill: Color {
#if os(iOS)
    return Color(.quaternarySystemFill)
#elseif os(macOS)
    return Color.secondary
#endif
  }
  
  static var tertiaryLabel: Color {
#if os(iOS)
    return Color(.tertiaryLabel)
#elseif os(macOS)
    return Color.secondary
#endif
  }
}
