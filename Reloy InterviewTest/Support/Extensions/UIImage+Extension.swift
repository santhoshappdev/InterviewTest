

import Foundation
import UIKit


extension UIImageView {
    func load(_ imageUrl: String) {
        
        guard let url = URL(string: imageUrl) else {
            print("imageStr error")
            self.image = UIImage(named: "noimage")
            return}
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
