//
//  Delegate.swift
//  rush
//
//  Created by Mfundo MTHETHWA on 2018/10/06.
//  Copyright © 2018 Mfundo MTHETHWA. All rights reserved.
//

import UIKit

protocol Delegate: class {
    func handleTopics(_ topics: [Topic])
    func handleErrors(_ error: NSError)
}
