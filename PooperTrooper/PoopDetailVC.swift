import UIKit
import MapKit
import Cosmos

class PoopDetailVC: UITableViewController {
    var poop: Poop!
    
    @IBOutlet var poopSelfie: UIImageView!
    @IBOutlet var poopTopPlace: UILabel!
    
    @IBOutlet var poopDateAndTime: UILabel!
    @IBOutlet var poopPlace: UILabel!
    @IBOutlet var poopComment: UILabel!
    @IBOutlet var poopRating: CosmosView!
    
    @IBOutlet var poopLocation: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = poop.place
        
        poopSelfie.image = poop.selfie
        poopTopPlace.text = poop.place
        
        poopDateAndTime.text = poop.dateAndTime
        poopPlace.text = poop.place
        poopComment.text = poop.comment
        poopRating.rating = Double(poop.ratingRaw)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        poopLocation.region = poop.location
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
