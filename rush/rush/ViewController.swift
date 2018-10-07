import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webPageView: UIWebView!
    var token: Token?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=fe55637c623031cb20c5748d1930eb4046709541d4840c142df148809416b070&redirect_uri=Forum%3A%2F%2Foauth%2F&response_type=code")
        let request = URLRequest(url: url!)
        webPageView.loadRequest(request)
    }
    
    @IBAction func unWindSegue(_ segue: UIStoryboardSegue) {
        let url = URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=fe55637c623031cb20c5748d1930eb4046709541d4840c142df148809416b070&redirect_uri=Forum%3A%2F%2Foauth%2F&response_type=code")
        let request = URLRequest(url: url!)
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        webPageView.loadRequest(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue" {
            if let destination = segue.destination as? UINavigationController {
                if let homeViewConroller = destination.topViewController as? HomeViewController {
                    homeViewConroller.token = self.token
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url?.absoluteString
        let oauth = URLComponents(string: url!)?.host
        let forum = URLComponents(string: url!)?.scheme
        var json: String?
        var error: String?

        if oauth == "oauth" && forum == "forum" {
            if let queryItems = URLComponents(string: url!)?.queryItems {
                for items in queryItems {
                    if items.name == "code" {
                        if let itemValue = items.value {
                            json = itemValue
                        }
                    }
                    else if items.name == "error" {
                        if let itemValue = items.value {
                            error = itemValue
                        }
                    }
                }
            }
        }
        if let Error = error {
            let alertController = UIAlertController(title: "ERROR", message: "\(Error).self: You not authorized to access the 42 API", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        if let JSON = json {
            let params = "grant_type=client_credentials&client_id=\(Login.UID)&client_secret=\(Login.SECRET)&code=\(JSON)&redirect_uri=Forum%3A%2F%2Foauth%2F"
            let url = "https://api.intra.42.fr/oauth/token?\(params)"
            let Url = URL(string: url)!
            var request = URLRequest(url: Url)
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let err = error {
                    print(err)
                }
                else if let d = data {
                    do {
                        if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            self.token = Token(token: resp)
                            //self.getId((self.token?.access_token)!)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "mySegue", sender: self.token)
                            }
                        }
                    }
                    catch (let err) {
                        print(err)
                    }
                }
            }
            task.resume()
            return false
        }
        return true
    }
    
    func getId(_ token: String) {
        var urlRequest = URLRequest(url: URL(string: "https://api.intra.42.fr/oauth/token/info?access_token=" + token)!)
        urlRequest.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    let resp = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions()) as? NSDictionary
                    let defaults = UserDefaults.standard
                    defaults.setValue(resp!.value(forKey: "resource_owner_id")!, forKey: "authorId")
                    defaults.synchronize()
                    if defaults.string(forKey: "authorId") != nil {
                        print("valid id")
                    }
                } catch _ {
                    print("Connection Error")
                }
            }
        }
        task.resume()
    }
}

