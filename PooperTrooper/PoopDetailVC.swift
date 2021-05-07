import UIKit
import MapKit
import Cosmos

class PoopDetailVC: UITableViewController {
    var poop: Poop!
    
    @IBOutlet weak var poopSelfie: UIImageView!
    @IBOutlet weak var poopTopPlace: UILabel!
    @IBOutlet weak var poopDateAndTime: UILabel!
    @IBOutlet weak var poopPlace: UILabel!
    @IBOutlet weak var poopComment: UILabel!
    @IBOutlet weak var poopRating: CosmosView!
    @IBOutlet weak var poopLocation: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = poop.place
        poopSelfie.image = poop.selfie
        poopTopPlace.text = poop.place
        poopDateAndTime.text = poop.dateAndTime
        poopPlace.text = poop.place
        poopComment.text = poop.comment
        poopRating.rating = Double(poop.ratingRaw)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        poopLocation.region = poop.location
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
