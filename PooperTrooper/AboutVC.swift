import UIKit

class AboutVC: UITableViewController {
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var appBuild: UILabel!
    
    @IBAction func settingsClosed(unwindSegue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appVersion.text = UserDefaults.standard.appVersion
        appBuild.text = UserDefaults.standard.appBuild
    }
}
