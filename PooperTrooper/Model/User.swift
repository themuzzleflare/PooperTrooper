import Foundation
import CloudKit
import UIKit

struct User: Hashable, Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    
    var username: String = ""
    
    var profilePhotoRaw: CKAsset?
    var profilePhoto: UIImage {
        let noImage = UIImage(systemName: "person.circle")!
        
        if let url = profilePhotoRaw?.fileURL {
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
