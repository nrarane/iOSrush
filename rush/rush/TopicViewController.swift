//
//  TopicViewController.swift
//  rush
//
//  Created by Felix Ntokozo THWALA on 2018/10/07.
//  Copyright © 2018 Mfundo MTHETHWA. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var messages: Dictionary<String,Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = self.messages as? Dictionary<String,Any> {
            if let size = messages.count as? Int {
                return size
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageTableViewCell
        
        
        //let item = self.messages![indexPath.row]
        
        //let author = item["author"]! as! Dictionary<String, Any>
        //let login = author["login"]!
        //let dateTime = item["created_at"]!
        //let message = item["content"]!
        
//        cell.loginLabel.text = login as! String
//        cell.dateTimeLabel.text = dateTime as! String
//        cell.messageLabel.text = message as! String

        cell.loginLabel.text = ""
        cell.dateTimeLabel.text = ""
        cell.messageLabel.text = self.messages?["message"] as! String
        print(self.messages?["message"] as! String)
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
