import UIKit

class TextFieldCustomDelegate: NSObject, UITextFieldDelegate {
    
    //@IBOutlet weak var textField: UITextField! // Link this to a UITextField in your storyboard
    var limitLength:Int = 10
    var mask:String = ""
    
    init(limitLen:Int=10) {
        self.limitLength = limitLen
    }
    init(limitLen:Int=10,mask:String="") {
        self.limitLength = limitLen
        self.mask = mask
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if (self.mask != ""){
            textField.text = formattedNumber(number: newString)
            return false;
        }
        return newLength <= limitLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = self.mask
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                if (ch==cleanPhoneNumber[index]){
                    index = cleanPhoneNumber.index(after: index)
                }
                result.append(ch)
            }
        }
        return result
    }
}
