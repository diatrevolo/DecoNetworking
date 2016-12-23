//
//  ViewController.swift
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
