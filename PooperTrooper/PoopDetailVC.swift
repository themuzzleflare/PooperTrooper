import UIKit
import MapKit

class PoopDetailVC: UITableViewController {
    var poop: Poop!
    
    @IBOutlet var poopSelfie: UIImageView!
    @IBOutlet var poopTopPlace: UILabel!
    
    @IBOutlet var poopDateAndTime: UILabel!
    @IBOutlet var poopPlace: UILabel!
    @IBOutlet var poopComment: UILabel!
    @IBOutlet var poopRating: UILabel!
    
    @IBOutlet var poopLocation: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = poop.place
        
        poopSelfie.image = poop.selfie
        poopTopPlace.text = poop.place
        
        poopDateAndTime.text = poop.dateAndTime
        poopPlace.text = poop.place
        poopComment.text = poop.comment
        poopRating.text = poop.rating
        
        poopLocation.region = poop.location
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
