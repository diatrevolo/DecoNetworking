//
//  DecoNetworkOperation.swift
//  DecoNetworking
//
//  Created by Roberto Osorio-Goenaga on 12/22/16.
//  Copyright © 2016 Roberto Osorio-Goenaga. All rights reserved.
//

import UIKit

class DecoNetworkOperation: Operation {

    var finishedState: Bool = false
    override public var isFinished: Bool {
        get {
            return finishedState
        }
        set (newState) {
            willChangeValue(forKey: "isFinished")
            finishedState = newState
            didChangeValue(forKey: "isFinished")
        }
    }
    let incomingData = NSMutableData()
    var task: (_ data: NSMutableData)->()
    
    init(task: @escaping (_ data: NSMutableData)->()) {
        self.task = task
        super.init()
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        task(incomingData)
    }
}
