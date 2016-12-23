//
//  DecoNetworkingManager.swift
//  DecoNetworking
//
//  Created by Roberto Osorio-Goenaga on 12/22/16.
//  Copyright © 2016 Roberto Osorio-Goenaga. All rights reserved.
//

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
