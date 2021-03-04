import UIKit
import CloudKit

class PoopsVC: UITableViewController {
    var modelData = ModelData()
    
    var operation: CKQueryOperation!
    
    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        self.fetchPoops()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        self.fetchPoops()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.poops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poopCell", for: indexPath) as! PoopCell
        
        let poop = modelData.poops[indexPath.row]
        
        cell.leftImage.image = poop.selfie
        cell.topLabel.text = poop.place
        cell.bottomSubtitle.text = poop.comment
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let poop = modelData.poops[indexPath.row]
        
            let database = CKContainer.default().privateCloudDatabase
            let operation = CKModifyRecordsOperation(recordIDsToDelete: [poop.recordID!])
            
            operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, operationError in
                if let error = operationError {
                    print(error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.fetchPoops()
                    }
                }
            }
            database.add(operation)
    }
    
    private func fetchPoops() {
        let database = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Poops", predicate: predicate)
        
        operation = CKQueryOperation(query: query)
        operation.zoneID = .default
        operation.desiredKeys = ["comment", "dateAndTime", "location", "place", "rating", "selfie"]
        operation.resultsLimit = 200
        
        var newPoops = [Poop]()
        
        operation.recordFetchedBlock = { record in
            var poop = Poop()
            
            poop.recordID = record.recordID
            poop.comment = record["comment"] as? String ?? ""
            poop.place = record["place"] as? String ?? ""
            poop.ratingRaw = record["rating"] as? Int64 ?? 0
            poop.locationRaw = record["location"] as! CLLocation?
            poop.dateAndTimeRaw = record["dateAndTime"] as! Date?
            poop.selfieRaw = record["selfie"] as! CKAsset?
            
            newPoops.append(poop)
        }
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    self.refreshControl?.endRefreshing()
                    print(error.localizedDescription)
                } else {
                    self.modelData.poops = newPoops
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    self.refreshControl?.endRefreshing()
                }
            }
        }
        database.add(operation)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPoopDetail" {
            let vc = segue.destination as! PoopDetailVC
            vc.poop = modelData.poops[tableView.indexPathForSelectedRow!.row]
        }
    }
}
