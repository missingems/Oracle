import Foundation
import ScryfallKit

class JSONLoader {
  func loadJsonFromFile<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
    // Adjust the bundle reference to the bundle for the specified class
    let bundle = Bundle(for: JSONLoader.self)
    
    guard let fileUrl = bundle.url(forResource: filename, withExtension: "json") else {
      print("Could not find \(filename) in the module bundle.")
      return nil
    }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
      let data = try Data(contentsOf: fileUrl)
      let decodedData = try decoder.decode(T.self, from: data)
      return decodedData
    } catch {
      print("Error loading or decoding \(filename): \(error)")
      return nil
    }
  }

}

extension MTGSet {
  static var stubs: [Self] {
    let loader = JSONLoader()
    let list = loader.loadJsonFromFile("setsSample", as: ObjectList<MTGSet>.self)
    return list?.data ?? []
  }
}

extension Card {
  static var stubs: [Self] {
    let loader = JSONLoader()
    let list = loader.loadJsonFromFile("cards", as: ObjectList<Card>.self)
    return list?.data ?? []
  }
}
