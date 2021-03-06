import UIKit

class AboutVC: UITableViewController {
    @IBOutlet var appVersion: UILabel!
    @IBOutlet var appBuild: UILabel!
    
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appVersion.text = version
        appBuild.text = build
    }

    // MARK: - Table view data source
}
