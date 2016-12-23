//
//  ViewController.swift
//  DecoSample
//
//  Created by Roberto Osorio Goenaga on 12/23/16.
//  Copyright © 2016 Roberto Osorio-Goenaga. All rights reserved.
//

import UIKit
import DecoNetworking

class ViewController: UIViewController {

    var myCoolObject: MyCoolModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DecoNetworkingManager.sharedManager.performURLRequest(DecoRequest(url: NSURL(string: "https://exoticcars.enterprise.com/etc/designs/exotics/clientlibs/dist/img/homepage/Homepage-Hero-Car.png") as! URL)) { data in
            let thisImage = UIImage(data: data as Data)
            let imageView = UIImageView(image: thisImage)
            DispatchQueue.main.async {
                self.view.addSubview(imageView)
            }
        }
        myCoolObject = MyCoolModel(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: MyCoolModelDelegate {
    func hydrationComplete(sender: NSObject) {
        if let coolObject = sender as? MyCoolModel {
            print("ID: \(coolObject._id ?? 0)\nUserID: \(coolObject.userId ?? 0)\nTitle:\(coolObject.title ?? "None")\nBody:\(coolObject.body ?? "None")")
        }
    }
}
