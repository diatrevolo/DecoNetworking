//
//  MyCoolModel.swift
//  DecoSample
//
//  Created by Roberto Osorio-Goenaga on 12/23/16.
//

//  MIT License
//
//  Copyright (c) 2016 Roberto J. Osorio-Goenaga
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import DecoNetworking

class MyCoolModel: NSObject {
  
  var userId: Int?
  var _id: Int?
  var title: String?
  var body: String?
  
  var delegate: MyCoolModelDelegate? = nil
  
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
