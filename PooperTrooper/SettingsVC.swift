import UIKit

class SettingsVC: UITableViewController {
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func mapZoomPicked(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UserDefaults.standard.setValue("Near", forKey: "mapZoom")
        } else if sender.selectedSegmentIndex == 1 {
            UserDefaults.standard.setValue("Medium", forKey: "mapZoom")
        } else {
            UserDefaults.standard.setValue("Far", forKey: "mapZoom")
        }
    }
    
    @IBOutlet var mapZoomPicker: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "mapZoom") == "Near" || UserDefaults.standard.string(forKey: "mapZoom") == nil {
            mapZoomPicker.selectedSegmentIndex = 0
        } else if UserDefaults.standard.string(forKey: "mapZoom") == "Medium" {
            mapZoomPicker.selectedSegmentIndex = 1
        } else {
            mapZoomPicker.selectedSegmentIndex = 2
        }
    }
    
    // MARK: - Table view data source
}
