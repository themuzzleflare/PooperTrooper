import UIKit
import CloudKit
import Cosmos
import CoreLocation

class NewPoopVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    let ipc = UIImagePickerController()
        
    let lm = CLLocationManager()
    
    var selectedSelfie: URL?
    
    @IBOutlet var submitButton: UIBarButtonItem!
    @IBOutlet var chooseButton: UIButton!
    
    @IBOutlet var recordDateAndTime: UIDatePicker!
    @IBOutlet var recordPlace: UITextField!
    @IBOutlet var recordComment: UITextField!
    @IBOutlet var recordRating: CosmosView!
    
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.ipc.sourceType = .camera
            self.present(self.ipc, animated: true)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.ipc.sourceType = .photoLibrary
            self.present(self.ipc, animated: true)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            self.selectedSelfie = nil
            sender.isSelected = false
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(cameraAction)
        ac.addAction(photoLibraryAction)
        if sender.isSelected {
            ac.addAction(removeAction)
        }
        ac.addAction(cancelAction)
        
        self.present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ipc.dismiss(animated: true)
        
        if ipc.sourceType == .photoLibrary {
            let image = info[.imageURL] as! URL
            self.selectedSelfie = image
            DispatchQueue.main.async {
                self.chooseButton.isSelected = true
            }
        } else {
            let image = info[.originalImage] as! UIImage
            if let imgData = image.jpegData(compressionQuality: 0.0) {
                do {
                    let path = NSTemporaryDirectory().appending("\(UUID().uuidString).jpeg")
                    let url = URL(fileURLWithPath: path)
                    try imgData.write(to: url, options: .atomic)
                    self.selectedSelfie = url
                    DispatchQueue.main.async {
                        self.chooseButton.isSelected = true
                    }
                } catch {
                    let ac = UIAlertController(title: "Error", message: "An error occurred. The captured photo was not selected.", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
                    ac.addAction(dismissAction)
                    DispatchQueue.main.async {
                        self.present(ac, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func submitAction(_ sender: UIBarButtonItem) {
        if !self.recordPlace.text!.isEmpty && !self.recordComment.text!.isEmpty && self.recordRating.rating != 0 {
            DispatchQueue.main.async {
                let loadingView = UIActivityIndicatorView(style: .medium)
                loadingView.startAnimating()
                self.navigationItem.setRightBarButton(UIBarButtonItem(customView: loadingView), animated: true)
            }
            let database = CKContainer.default().privateCloudDatabase
            let record = CKRecord(recordType: "Poops")
            record.setValue(recordDateAndTime.date, forKey: "dateAndTime")
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
                    let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
                    ac.addAction(dismissAction)
                    DispatchQueue.main.async {
                        self.navigationItem.setRightBarButton(self.submitButton, animated: true)
                        self.present(ac, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.setRightBarButton(self.submitButton, animated: true)
                        self.dismiss(animated: true)
                    }
                }
            }
            database.add(operation)
        } else {
            let ac = UIAlertController(title: "Error", message: "One or more required fields are empty.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
            ac.addAction(dismissAction)
            DispatchQueue.main.async {
                self.present(ac, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lm.delegate = self
        lm.startUpdatingLocation()
        
        ipc.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
