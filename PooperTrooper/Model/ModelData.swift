import Foundation
import CoreLocation

final class ModelData: ObservableObject {
    @Published var poops: [Poop] = []
    @Published var user = User()
}

extension UserDefaults {
    @objc dynamic var mapZoom: String {
        get {
            return string(forKey: "mapZoom") ?? "Near"
        }
        set {
            set(newValue, forKey: "mapZoom")
        }
    }
    @objc dynamic var appVersion: String {
        get {
            return string(forKey: "appVersion") ?? "Unknown"
        }
    }
    @objc dynamic var appBuild: String {
        get {
            return string(forKey: "appBuild") ?? "Unknown"
        }
    }
}

var delta: CLLocationDegrees {
    switch UserDefaults.standard.mapZoom {
        case "Near": return 0.02
        case "Medium": return 0.2
        case "Far": return 2
        default: return 0.02
    }
}
