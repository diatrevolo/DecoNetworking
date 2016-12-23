# DecoNetworking
Decorator pattern-based networking wrapper for URLSession, written in Swift 3.

Deco works by lightly wrapping URLSession networking in a small, manageable framework.

To make a URL request:
```swift
DecoNetworkingManager.sharedManager.performURLRequest(DecoRequest(url: NSURL(string: "https://exoticcars.enterprise.com/etc/designs/exotics/clientlibs/dist/img/homepage/Homepage-Hero-Car.png") as! URL)) { data in
    let thisImage = UIImage(data: data as Data)
    let imageView = UIImageView(image: thisImage)
    DispatchQueue.main.async {
        self.view.addSubview(imageView)
    }
}
```

To create a self-hydrating model using `DecoNetworkingProtocol`:
```swift
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
```
Instantiating `MyCoolModel` will make the necessary network calls and notify its delegate of completion.
