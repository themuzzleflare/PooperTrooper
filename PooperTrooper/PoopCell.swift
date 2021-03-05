import UIKit

class PoopCell: UITableViewCell {
    @IBOutlet var poopSelfie: UIImageView!
    @IBOutlet var poopPlace: UILabel!
    @IBOutlet var poopComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
