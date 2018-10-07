import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var token: Token?
    
    
    var deToken = ""
    var topicsBackup: [Dictionary<String,Any>]?
    @IBOutlet weak var topicsTableView: UITableView!
    var selectedItem:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let UID = "ce3639778c7e09492c14afd96f1351585b88a7b533776bf487f45483c789a9be"
        let SECRET = "baa1b092885602618b1ff23cfcb97344c3179c60973aad7a2af9a4f62f0bc9f4"
        let BEARER = ((UID + ":" + SECRET).data(using: String.Encoding.utf8, allowLossyConversion: true))!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else {return}
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if let token = json["access_token"]
                    {
                        self.deToken = token as! String
                        _ = self.getTopic()
                    }
                } catch {
                    print(error)
                }
            }
        })
        
        task.resume()
    }
    
    func getTopic() {
        print("Started connection")
        let authEndPoint: String = "https://api.intra.42.fr/v2/topics"
        
        let url = URL(string: authEndPoint)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(self.deToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let session = URLSession.shared
        let requestPost = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String,Any>] {
                        self.topicsBackup = dictonary
                        DispatchQueue.main.async {
                            self.topicsTableView.reloadData()
//                            print(type(of: self.topicsBackup![0]))
                        }
                    }
                    else {
                        print("Dictionary is empty")
                    }
                } catch let error {
                    print(error)
                }
                print("Done loading data")
            }
            else {
                print("Data is null")
            }
        }
        requestPost.resume()
        print("End token")
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let topics = self.topicsBackup as? [Dictionary<String,Any>] {
            if let size = topics.count as? Int {
                return size
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicTableViewCell
        
        let item = self.topicsBackup![indexPath.row]
        let author = item["author"]! as! Dictionary<String, Any>
        let login = author["login"]!
        let dateTime = item["created_at"]!
        let topicName = item["name"]!
        
        cell.loginLabel.text = login as! String
        cell.dateTimeLabel.text = dateTime as! String
        cell.topicNameLabel.text = topicName as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        topicsTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueToMessages", sender: topicsTableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = topicsTableView.indexPathsForSelectedRows?.first?.row {
            if let destVs = segue.destination as? TopicViewController {
                destVs.messages = self.topicsBackup![index]
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
