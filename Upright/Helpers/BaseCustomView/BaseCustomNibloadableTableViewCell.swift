import UIKit

class BaseCustomNibloadableTableViewCell: UITableViewCell, ViewIdentifiable, NibLoadable {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
