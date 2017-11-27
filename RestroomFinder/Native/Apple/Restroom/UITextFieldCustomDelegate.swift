import UIKit

class TextFieldCustomDelegate: NSObject, UITextFieldDelegate {
    
    //@IBOutlet weak var textField: UITextField! // Link this to a UITextField in your storyboard
    var limitLength:Int = 10
    
    init(limitLen:Int=10) {
        self.limitLength = limitLen
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
}