import UIKit

class TextViewCustomDelegate: NSObject, UITextViewDelegate {
    
    //@IBOutlet weak var textField: UITextField! // Link this to a UITextField in your storyboard
    var limitLength:Int = 50
    
    init(limitLen:Int=50) {
        self.limitLength = limitLen
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        guard let tempText = textView.text else { return true }
        let newLength = tempText.characters.count + text.characters.count - range.length
        return newLength <= limitLength

    }
}