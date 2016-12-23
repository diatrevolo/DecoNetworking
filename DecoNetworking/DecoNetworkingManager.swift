//
//  DecoNetworkingManager.swift
//  DecoNetworking
//
//  Created by Roberto Osorio-Goenaga on 12/22/16.
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

public class DecoNetworkingManager: NSObject {
    
    public static let sharedManager = DecoNetworkingManager()
    
    fileprivate var username = String()
    fileprivate var password = String()
    let delegateQueue = OperationQueue()
    public var delegate: DecoNetworkingProtocol?
    
    public func performURLRequest(_ request:DecoRequest, task:@escaping (_ data: NSMutableData) -> ()) {
        let operation = DecoNetworkOperation { data in
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: self.delegateQueue)
            let task = session.dataTask(with: request.request) { incomingData, response, error in
                data.append(incomingData!)
                task(data)
            }
            task.resume()
        }
        DecoNetworkOperationQueue.sharedQueue.addOperation(operation)
    }
    
    public func performURLRequest(_ request:DecoRequest) {
        let operation = DecoNetworkOperation { data in
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: self.delegateQueue)
            let task = session.dataTask(with: request.request) { incomingData, response, error in
                data.append(incomingData!)
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                    self.delegate?.hydrateModelWithObject(object: dictionary as! Dictionary<String, Any>)
                } catch {
                    print(error)
                }
                
            }
            task.resume()
        }
        DecoNetworkOperationQueue.sharedQueue.addOperation(operation)
    }
    
    public func setAuthenticationCredentials(username: String, password: String) {
        self.username = username
        self.password = password
    }

}

extension DecoNetworkingManager: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.previousFailureCount > 0 {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else {
            let credential = URLCredential(user:username, password:password, persistence: .forSession)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
        }
    }
}

public protocol DecoNetworkingProtocol {
    func hydrateModelWithObject(object: Dictionary<String, Any>)
}
