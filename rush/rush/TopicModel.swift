//
//  TopicModel.swift
//  rush
//
//  Created by Mfundo MTHETHWA on 2018/10/07.
//  Copyright © 2018 Mfundo MTHETHWA. All rights reserved.
//

import UIKit

struct Topic: CustomStringConvertible {
    var description: String {
        return "\(name)"
    }
    
    let id: Int
    let name: String
    let author: [String: AnyObject]
    let created_at: String
}

struct Messages: CustomStringConvertible {
    var description: String {
        return "\(name)"
    }
    
    let id: Int
    let name: String
    let author: [String: AnyObject]
    let kind: String
    let created_at: String
    let updated_at: String
    let messages: [String:AnyObject]
    let message_url: String
    let tag: [AnyObject]
}
