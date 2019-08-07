

import UIKit
import SafariServices


extension UINavigationController {
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
}
extension UIStackView {
    func setBackgroundColor(_ color: UIColor) {
        let backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = color
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
}
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
extension UIDatePicker {
    
    var textColor: UIColor? {
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
    }
    
}

extension UIView{

 
        
        func showLoader(activityColor: UIColor, backgroundColor: UIColor) {
            let backgroundView = UIView()
            backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            backgroundView.backgroundColor = backgroundColor
            backgroundView.tag = 475647
            
            var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            activityIndicator.color = activityColor
            activityIndicator.startAnimating()
            self.isUserInteractionEnabled = false
            backgroundView.addSubview(activityIndicator)
            
            self.addSubview(backgroundView)
        }
        
        func removeLoader() {
            if let background = viewWithTag(475647){
                background.removeFromSuperview()
            }
            self.isUserInteractionEnabled = true
        }
        /** Loads instance from nib with the same name. */
        func loadNib() -> UIView {
            let bundle = Bundle(for: type(of: self))
            let nibName = type(of: self).description().components(separatedBy: ".").last!
            let nib = UINib(nibName: nibName, bundle: bundle)
            return nib.instantiate(withOwner: self, options: nil).first as! UIView
        }

    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    
    @IBInspectable var borderColor: UIColor {
        get {
            return self.borderColor
        }
        set {
            self.addBorderColor(color: newValue)
        }
    }
    func addBorderColor(color: UIColor )
    {
       // self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    //Allow to add shadow of any View from story board attributes
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    //Allow to change the corner radius of any View from story board attributes
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var cornerRadiusByPercentage: CGFloat {
        set {
            
            let radius = (newValue * (UIScreen.main.bounds.height - self.frame.height)) / 2
            
            self.layer.cornerRadius = radius
        }
        get {
            return layer.cornerRadius
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    
    override open func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
    }
    
}
extension UITextField{
    //Allow to change the place holder of any TextField from story board attributes
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    
    
    
    
    @IBInspectable var leftPadding: CGFloat {
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
            
        }
        get {
            return self.leftView?.borderWidth ?? 0.0
        }
    }
    
    @IBInspectable public var rightPadding: CGFloat {
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        }
        get {
            return self.rightView?.borderWidth ?? 0.0
            
        }
    }
    
}
extension UIButton {
    
    func alignTextBelow(spacing: CGFloat = 0.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
//    var topViewController: UIViewController? {
//            return self.topViewController(currentViewController: self)
//    }
//
//    private func topViewController(currentViewController: UIViewController) -> UIViewController {
//            if let tabBarController = currentViewController as? UITabBarController,
//                let selectedViewController = tabBarController.selectedViewController {
//                return self.topViewController(currentViewController: selectedViewController)
//            } else if let navigationController = currentViewController as? UINavigationController,
//                let visibleViewController = navigationController.visibleViewController {
//                return self.topViewController(currentViewController: visibleViewController)
//            } else if let presentedViewController = currentViewController.presentedViewController {
//                return self.topViewController(currentViewController: presentedViewController)
//            } else {
//                return currentViewController
//            }
//        }
//
}

extension String {
  
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    

    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func isValidPassword() -> Bool{
        if self.count >= 8{
            return true
        }
        else{
            return false
        }
    }
    var parseHtml: String {
        
        let encodedData = self.data(using: String.Encoding.utf8)!
        do {
            let x = try NSAttributedString(data: encodedData,     options: [.documentType: NSAttributedString.DocumentType.html,
                                                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                           documentAttributes: nil)
            let message = x.string
            return message
        } catch let error as NSError {
            print(error.localizedDescription)
            return ""
        }
    }
    func checkCount() -> Bool{
        if self.count >= 191{
            return false
        }else{
            return true
        }
    }
    func verifyUrl () -> Bool {
        if self.range(of:".") != nil {
            return true
        }
        else{
            return false
        }
    }
    public func isPhone()->Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
}
extension UIImage {
               func fixOrientation() -> UIImage {
                guard imageOrientation != .up else { return self }

                var transform: CGAffineTransform = .identity

                switch imageOrientation {
                case .down, .downMirrored:
                    transform = transform.translatedBy(x: size.width ,y: size.height).rotated(by: .pi)
                case .left, .leftMirrored:
                    transform = transform.translatedBy(x: size.width, y: 0).rotated(by: .pi)
                case .right, .rightMirrored:
                    transform = transform.translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
                case .upMirrored:
                    transform = transform.translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
                default: break
                }

                guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace,
                    let context: CGContext = CGContext(data: nil,
                                                       width: Int(size.width),
                                                       height: Int(size.height),
                                                       bitsPerComponent: cgImage.bitsPerComponent,
                                                       bytesPerRow: 0,
                                                       space: colorSpace,
                                                       bitmapInfo: cgImage.bitmapInfo.rawValue)
                else { return self }
                context.concatenate(transform)
                var rect: CGRect
                switch imageOrientation {
                case .left, .leftMirrored, .right, .rightMirrored:
                    rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
                default:
                    rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                }
                context.draw(cgImage, in: rect)
                guard let image = context.makeImage() else { return self }
                return UIImage(cgImage: image)
            }

    func isEqualToImage(image: UIImage) -> Bool {
        let data1 = self.pngData()! as NSData
        let data2 = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func reduce(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UIAlertController {
    
    /// Create new alert view controller.
    ///
    /// - Parameters:
    ///   - style: alert controller's style.
    ///   - title: alert controller's title.
    ///   - message: alert controller's message (default is nil).
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    convenience init(style: UIAlertController.Style, source: UIView? = nil, title: String? = nil, message: String? = nil, tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: style)
        
        // TODO: for iPad or other views
        let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        let root = UIApplication.shared.keyWindow?.rootViewController?.view
        
        //self.responds(to: #selector(getter: popoverPresentationController))
        if let source = source {
            //Log("----- source")
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = source.bounds
        } else if isPad, let source = root, style == .actionSheet {
            //Log("----- is pad")
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = CGRect(x: source.bounds.midX, y: source.bounds.midY, width: 0, height: 0)
            //popoverPresentationController?.permittedArrowDirections = .down
            popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        }
        
        if let color = tintColor {
            self.view.tintColor = color
        }
    }
}


