//
//  ApiGetInfo.swift
//  rush
//
//  Created by Mfundo MTHETHWA on 2018/10/07.
//  Copyright © 2018 Mfundo MTHETHWA. All rights reserved.
//

import UIKit

class ApiGetInfo {
    var token: Token?
    var topics: [Topic] = []
    var message: [Topic] = []
    weak var delegate: Delegate?
    
    init(delegate: Delegate?, token: Token) {
        self.delegate = delegate
        self.token = token
    }
    
    func APIInfo(_ topicTitle: String, topicContent: String) {
        let defauls = UserDefaults.standard
        if let authorId: String = defauls.string(forKey: "authorId") {
            let tab: [String: AnyObject] = [
                "topic": [
                    "author_id":authorId,
                    "name": topicTitle,
                    "curses_id": [
                        "1"
                    ],
                    "messages_attributes": [
                        [
                            "content": topicContent,
                            "author_id": authorId
                        ]
                    ],
                    "tag_id": [
                        "8"
                    ]
                ] as AnyObject
            ]
            do {
                let json = try JSONSerialization.data(withJSONObject: tab, options: [])
                var UrlRequest = URLRequest(url: URL(string: "https://api.intra.42.fr/v2/topics?access_token=" + (token?.access_token)!)!)
                UrlRequest.httpMethod = "POST"
                UrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                UrlRequest.httpBody = json
                let session = URLSession.shared
                let task = session.dataTask(with: UrlRequest, completionHandler: { (data, response, error) -> Void in
                    if let err = error {
                        print(err)
                    } else if let d = data {
                        do {
                            let resp = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions())
                            print(resp)
                        } catch _ {
                            print("Connection Error")
                        }
                    }
                })
                task.resume()
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    func getTopics( _ page: Int) {
        var UrlRequest = URLRequest(url: URL(string: "https://api.intra.42.fr/v2/topics?access_token=" + (self.token?.access_token)! + "&page=\(page)")!)
        UrlRequest.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: UrlRequest, completionHandler: { (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let resp : [NSDictionary] = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
                        for topic in resp {
                            let id = topic.value(forKey: "id") as! Int
                            let name = topic.value(forKey: "name") as! String
                            let author = topic.value(forKey: "author") as! [String: AnyObject]
                            let created_at = topic.value(forKey: "created_at") as! String
                            self.topics.append(Topic(id: id, name: name, author: author, created_at: created_at))
                        }
                        DispatchQueue.main.async {
                            self.delegate?.handleTopics(self.topics)
                        }
                    }
                } catch _ {
                    print("Connection Error")
                }
            }
        })
        task.resume()
    }
    
    func getResponse(_ topicId: Int, page: Int) {
        var UrlRequest = URLRequest(url: URL(string: "https://api.intra.42.fr/v2/messages/\(topicId)/messages?access_token=" + (self.token?.access_token)! + "&page=\(page)")!)
        UrlRequest.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: UrlRequest, completionHandler: { (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let resp : [NSDictionary] = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
                        for topic in resp {
                            let id = topic.value(forKey: "id") as! Int
                            let name = topic.value(forKey: "name") as! String
                            let author = topic.value(forKey: "author") as! [String: AnyObject]
                            let created_at = topic.value(forKey: "created_at") as! String
                            self.message.append(Topic(id: id, name: name, author: author, created_at: created_at))
                        }
                        DispatchQueue.main.async {
                            self.delegate?.handleTopics(self.message)
                        }
                    }
                } catch _ {
                    print("Connection Error")
                }
            }
        })
        task.resume()
    }
}
