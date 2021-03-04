import UIKit
import CloudKit
import Cosmos
import CoreLocation

class NewPoopVC: UITableViewController, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate {
    let ipc = UIImagePickerController()
    
    let lm = CLLocationManager()
    
    var selectedSelfie: URL?
    
    @IBOutlet var recordDate: UIDatePicker!
    @IBOutlet var recordPlace: UITextField!
    @IBOutlet var recordComment: UITextField!
    @IBOutlet var recordRating: CosmosView!
    
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        self.present(ipc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ipc.dismiss(animated: true)
        let image = info[.imageURL] as! URL
        self.selectedSelfie = image
        self.tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ipc.dismiss(animated: true)
        self.selectedSelfie = nil
        self.tableView.reloadData()
    }
    
    @IBAction func submitAction(_ sender: UIBarButtonItem) {
        let database = CKContainer.default().privateCloudDatabase
        let record = CKRecord(recordType: "Poops")
        record.setValue(recordDate.date, forKey: "dateAndTime")
        record.setValue(recordPlace.text, forKey: "place")
        record.setValue(recordComment.text, forKey: "comment")
        record.setValue(Int64(recordRating.rating), forKey: "rating")
        if selectedSelfie != nil {
            record.setValue(CKAsset(fileURL: selectedSelfie!), forKey: "selfie")
        }
        record.setValue(CLLocation(latitude: lm.location?.coordinate.latitude ?? 0, longitude: lm.location?.coordinate.longitude ?? 0), forKey: "location")
        let operation = CKModifyRecordsOperation(recordsToSave: [record])
        
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, operationError in
            if let error = operationError {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
        database.add(operation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lm.delegate = self
        lm.startUpdatingLocation()
        
        ipc.delegate = self
        ipc.sourceType = .photoLibrary
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
