import Foundation
import UIKit

@IBDesignable
class PaddingLabel: UILabel {
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        //let insetRect = bounds.inset(by: textEdgeInsets)
        let insetRect = UIEdgeInsetsInsetRect(bounds,textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
        //return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {

        super.drawText(in: UIEdgeInsetsInsetRect(rect, textEdgeInsets))
        
        //super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    @IBInspectable
    var routeCorners: Bool {
        set {
            layer.cornerRadius = frame.size.height/5.0
            layer.masksToBounds = newValue }
        get { return layer.masksToBounds }
    }
    
    @IBInspectable
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
}
