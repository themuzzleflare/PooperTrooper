import UIKit

class PoopCell: UITableViewCell {
    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
