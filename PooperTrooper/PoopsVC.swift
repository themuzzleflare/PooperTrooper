import UIKit
import CloudKit

class PoopsVC: UITableViewController {
    private var modelData = ModelData()
    private var operation: CKQueryOperation!
    
    @IBAction func addPoopClosed(unwindSegue: UIStoryboardSegue) {
        fetchPoops()
    }
    
    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        fetchPoops()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        fetchPoops()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.poops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poopCell", for: indexPath) as! PoopCell
        let poop = modelData.poops[indexPath.row]
        cell.poopSelfie.image = poop.selfie
        cell.poopPlace.text = poop.place
        cell.poopComment.text = poop.comment
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
                self.fetchPoops()
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
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    print(error.localizedDescription)
                } else {
                    self.modelData.poops = newPoops
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
        database.add(operation)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPoopDetail" {
            let vc = segue.destination as! PoopDetailVC
            vc.poop = modelData.poops[tableView.indexPathForSelectedRow!.row]
        }
    }
}
