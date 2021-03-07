import Foundation
import CloudKit
import MapKit
import UIKit

struct Poop: Hashable, Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    
    var locationRaw: CLLocation?
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: locationRaw?.coordinate.latitude ?? 0,
            longitude: locationRaw?.coordinate.longitude ?? 0)
    }
    var location: MKCoordinateRegion {
        return MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
    }
    
    var place: String = ""
    var comment: String = ""
    
    var ratingRaw: Int64 = 0
    var rating: String {
        return "\(ratingRaw.description)/5"
    }
    
    var dateAndTimeRaw: Date?
    var dateAndTime: String {
        if let date = dateAndTimeRaw {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            return dateFormatter.string(from: date)
        } else {
            return "Unknown"
        }
    }
    
    var selfieRaw: CKAsset?
    var selfie: UIImage {
        let noImage = UIImage(systemName: "square")!
        
        if let url = selfieRaw?.fileURL {
            if let data = try? Data(contentsOf: url) {
                if let uiIcon = UIImage(data: data) {
                    return uiIcon
                } else {
                    return noImage
                }
            } else {
                return noImage
            }
        } else {
            return noImage
        }
    }
}
