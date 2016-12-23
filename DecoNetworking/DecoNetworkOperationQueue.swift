//
//  DecoNetworkOperationQueue.swift
//  DecoNetworking
//
//  Created by Roberto Osorio-Goenaga on 12/22/16.
//  Copyright © 2016 Roberto Osorio-Goenaga. All rights reserved.
//

import UIKit

class DecoNetworkOperationQueue: NSObject {

    static var sharedQueue = DecoNetworkOperationQueue()
    private var operationQueue = OperationQueue()
    
    func addOperation(_ operation:DecoNetworkOperation) {
        operationQueue.addOperation(operation)
    }
    
    func operationCount() -> Int {
        return operationQueue.operationCount
    }
    
}
