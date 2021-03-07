import Foundation
import CoreLocation

final class ModelData: ObservableObject {
    @Published var poops: [Poop] = []
    @Published var user = User()
}

var delta: CLLocationDegrees {
    switch UserDefaults.standard.string(forKey: "mapZoom") {
        case "Near", nil: return 0.02
        case "Medium": return 0.2
        case "Far": return 2
        default: return 0.02
    }
}
