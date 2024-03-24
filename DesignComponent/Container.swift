import SwiftUI

public struct Container<Content: View>: View {
  private let content: Content?
  
  public init(predicate: Bool, @ViewBuilder content: () -> Content) {
    if predicate {
      self.content = content()
    } else {
      self.content = nil
    }
  }
  
  public var body: some View {
    if let content {
      content
    } else {
      EmptyView()
    }
  }
}
