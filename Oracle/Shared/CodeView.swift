import SwiftUI

struct CodeView: View {
  let code: String
  
  var body: some View {
    Text(code)
      .font(.caption)
      .monospaced()
      .padding(.horizontal, 5)
      .background { Color(uiColor: .systemFill) }
      .clipShape(.buttonBorder)
      .multilineTextAlignment(.center)
  }
}
