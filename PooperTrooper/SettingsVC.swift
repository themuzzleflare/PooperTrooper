import UIKit

class SettingsVC: UITableViewController {
    @IBOutlet weak var mapZoomPicker: UISegmentedControl!

    @IBAction func mapZoomPicked(_ sender: UISegmentedControl) {
        UserDefaults.standard.mapZoom = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.mapZoom == "Near" {
            mapZoomPicker.selectedSegmentIndex = 0
        } else if UserDefaults.standard.mapZoom == "Medium" {
            mapZoomPicker.selectedSegmentIndex = 1
        } else if UserDefaults.standard.mapZoom == "Far" {
            mapZoomPicker.selectedSegmentIndex = 2
        }
    }
}
