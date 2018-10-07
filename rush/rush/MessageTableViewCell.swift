import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var message : (String, String, String)? {
        didSet {
            if let m = message {
                loginLabel?.text = m.0
                dateTimeLabel?.text = m.1
                messageLabel?.text = m.2
            }
        }
    }
}
