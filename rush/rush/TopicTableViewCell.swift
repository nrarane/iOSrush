import UIKit

class TopicTableViewCell: UITableViewCell {
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var topicNameLabel: UILabel!
    
    var topic : (String, String, String)? {
        didSet {
            if let m = topic {
                loginLabel?.text = m.0
                dateTimeLabel?.text = m.1
                topicNameLabel?.text = m.2
            }
        }
    }
}
