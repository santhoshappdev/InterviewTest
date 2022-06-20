
//Santhosh

import UIKit
import Foundation

extension UITableViewCell {
    
    /// Reuse Identifier String
    public class var reuseIdentifier: String {
        return "\(self.self)"
    }
    
    /// Registers the Nib with the provided table
    public static func registerWithTable(_ table: UITableView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: self.reuseIdentifier , bundle: bundle)
        table.register(nib, forCellReuseIdentifier: self.reuseIdentifier)
    }
    
}

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension UITableView {
    // Safely dequeue a `Reusable` item
    func dequeueReusable<T: Reusable>(_ cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier) as? T else {
            fatalError("Misconfigured cell type, \(cellClass)!")
        }
        return cell
    }
    
    // Safely dequeue a `Reusable` item for a given index path
    func dequeueReusable<T: Reusable>(_ cellClass: T.Type, forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellClass)!")
        }
        return cell
    }
}


extension UITableView {
    
    func reloadWithoutAnimation() {
        let lastScrollOffset = contentOffset
        beginUpdates()
        endUpdates()
        layer.removeAllAnimations()
        setContentOffset(lastScrollOffset, animated: false)
    }
}

