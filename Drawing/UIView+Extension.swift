import UIKit

extension UIView {
    var renderedImage: UIImage {
        let rect = bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
}
