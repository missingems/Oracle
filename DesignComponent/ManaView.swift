import SwiftUI

public struct ManaView: View {
  let identity: [String]
  let size: CGSize
  
  public init(identity: [String], size: CGSize) {
    self.identity = identity
    self.size = size
  }
  
  public var body: some View {
    HStack(spacing: 3) {
      ForEach(identity.indices, id: \.self) { index in
        Image(identity[index])
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: size.width, height: size.height)
          .background { Circle().fill(Color.black).offset(x: -1, y: 1.5) }
      }
    }
  }
}

