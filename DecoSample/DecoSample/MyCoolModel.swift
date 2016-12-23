//
//  MyCoolModel.swift
//  DecoSample
//
//  Created by Roberto Osorio Goenaga on 12/23/16.
//  Copyright © 2016 Roberto Osorio-Goenaga. All rights reserved.
//

import UIKit
import DecoNetworking

class MyCoolModel: NSObject {
    
    var userId: Int?
    var _id: Int?
    var title: String?
    var body: String?
    
    var delegate: MyCoolModelDelegate?
    
    init(delegate: MyCoolModelDelegate?) {
        super.init()
        self.delegate = delegate
        DecoNetworkingManager.sharedManager.delegate = self
        refreshModel()
    }
    
    func refreshModel() {
        DecoNetworkingManager.sharedManager.performURLRequest(DecoRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!))
    }
    
}

extension MyCoolModel: DecoNetworkingProtocol {
    func hydrateModelWithObject(object: Dictionary<String, Any>) {
        userId = object["userId"] as! Int?
        _id = object["id"] as! Int?
        title = object["title"] as! String?
        body = object["body"] as! String?
        delegate?.hydrationComplete(sender: self)
    }
}

protocol MyCoolModelDelegate {
    func hydrationComplete(sender: NSObject)
}
