import SwiftUI

public struct SectionView<Content: View>: View {
  private let content: Content
  
  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  public var body: some View {
    Group {
      VStack(spacing: 11) {
        content
      }
      .padding(.vertical, 11)
    }
    .background {
      Color.quaternarySystemFill
    }
    .clipShape(
      .rect(
        cornerRadii: .init(
          topLeading: 9,
          bottomLeading: 9,
          bottomTrailing: 9,
          topTrailing: 9
        )
      )
    )
    .overlay(
      RoundedRectangle(cornerRadius: 9.0).stroke(Color(.separator), lineWidth: 1 / Main.nativeScale)
    )
    .padding(EdgeInsets(top: 3, leading: 16, bottom: 3, trailing: 16))
  }
}
