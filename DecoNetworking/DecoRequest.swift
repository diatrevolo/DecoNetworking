//
//  DecoRequest.swift
//  DecoNetworking
//
//  Created by Roberto Osorio-Goenaga on 12/22/16.
//  Copyright © 2016 Roberto Osorio-Goenaga. All rights reserved.
//

import UIKit

public class DecoRequest: NSObject {
    
    let request: URLRequest
    var url: URL
    
    public init(url: URL) {
        self.url = url
        request = URLRequest(url: url)
        super.init()
    }

}

public protocol DecoRequestBuilderProtocol {
    func createRequestFrom(url: URL) -> DecoRequest
}
