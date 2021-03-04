import UIKit
import CloudKit

class ProfileVC: UITableViewController {
    var modelData = ModelData()
    
    @IBOutlet var profileUsername: UILabel!
    @IBOutlet var profileUsernameLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet var profilePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchProfile()
    }
    
    private func fetchProfile() {
        let database = CKContainer.default().publicCloudDatabase
        let operation = CKFetchRecordsOperation(recordIDs: [CKRecord.ID(recordName: CKCurrentUserDefaultName)])
        
        operation.perRecordCompletionBlock = { record, recordID, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.modelData.user = User(recordID: recordID, username: record?["username"] as? String ?? "", profilePhotoRaw: record?["profilePhoto"] as! CKAsset?)
            }
        }
        
        operation.fetchRecordsCompletionBlock = { recordsByRecordID, operationError in
            if let error = operationError {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.profileUsername.text = self.modelData.user.username
                    self.profileUsernameLoadingIndicator.stopAnimating()
                    self.profileUsername.isHidden = false
                    self.profilePhoto.image = self.modelData.user.profilePhoto
                }
            }
        }
        database.add(operation)        
    }
}
