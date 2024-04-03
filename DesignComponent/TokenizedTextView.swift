import SwiftUI

public struct TokenizedTextView: View {
  private var text: String
  private var font: UIFont
  private let paragraphSpacing: CGFloat
  
  public init(_ text: String, font: UIFont, paragraphSpacing: CGFloat) {
    self.text = text
    self.font = font
    self.paragraphSpacing = paragraphSpacing
  }
  
  @ViewBuilder
  func build() -> some View {
    VStack(alignment: .leading, spacing: paragraphSpacing) {
      ForEach(text.split(separator: "\n"), id: \.self) { element in
        build(elements: parseText(String(element)))
      }
    }
  }
  
  // Parses the given text and returns an array of either text or token identifiers
  private func parseText(_ text: String) -> [TextElement] {
    var elements: [TextElement] = []
    var currentText = ""
    var currentToken = ""
    var insideToken = false
    
    for char in text {
      if char == "{" {
        if !currentText.isEmpty {
          elements.append(.text(currentText))
          currentText = ""
        }
        insideToken = true
      } else if char == "}" && insideToken {
        insideToken = false
        elements.append(.token(currentToken))
        currentToken = ""
      } else if insideToken {
        currentToken.append(char)
      } else {
        currentText.append(char)
      }
    }
    
    // Add any remaining text after the last token
    if !currentText.isEmpty {
      elements.append(.text(currentText))
    }
    
    return elements
  }
  
  private func build(elements: [TextElement]) -> some View {
    var text: Text?
    
    elements.forEach { element in
      switch element {
      case let .text(value):
        if text == nil {
          text = Text(value).font(Font.system(size: self.font.pointSize))
        } else if let _text = text {
          text = _text + Text(value).font(Font.system(size: self.font.pointSize))
        }
        
      case let .token(value):
        if text == nil {
          text = getCustomImage(image: "{\(value)}", newSize: CGSize(width: font.pointSize, height: font.pointSize)).font(Font.system(size: self.font.pointSize))
        } else if let _text = text {
          text = _text + getCustomImage(image: "{\(value)}", newSize: CGSize(width: font.pointSize, height: font.pointSize)).font(Font.system(size: self.font.pointSize))
        }
      }
    }
    
    return (text ?? Text("")).fixedSize(horizontal: false, vertical: true)
  }
  
  private func getCustomImage(image: String, newSize: CGSize) -> Text {
    if let image = UIImage(named: image),
       let newImage = convertImageToNewFrame(image: image, newFrameSize: newSize) {
      return Text(Image(uiImage: newImage).resizable())
    } else {
      return Text("")
    }
  }
  
  func convertImageToNewFrame(image: UIImage, newFrameSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(newFrameSize, false, 0.0)
    image.draw(in: CGRect(origin: .zero, size: newFrameSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  public var body: some View {
    build()
  }
  
  enum TextElement: Hashable {
    case text(String)
    case token(String)
  }
}
