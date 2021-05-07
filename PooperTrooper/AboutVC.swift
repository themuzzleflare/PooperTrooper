import UIKit

class AboutVC: UITableViewController {
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var appBuild: UILabel!
    
    @IBAction func settingsClosed(unwindSegue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appName.text = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "PooperTrooper"
        appVersion.text = UserDefaults.standard.appVersion
        appBuild.text = UserDefaults.standard.appBuild
    }
}

extension AboutVC {
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String ?? "Copyright © 2021 Paul Tavitian"
    }
}
