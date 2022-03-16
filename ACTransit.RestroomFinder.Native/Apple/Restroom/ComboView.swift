//
//  ComboView.swift
//  Restroom
//
//  Created by DevTeam on 2/1/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit

protocol ComboViewDelegate: class{
    func comboViewChanged(_ selectedIndex: Int, item:ComboViewItem!)
}

class ComboViewItem{
    init(title:String, value:NSObject!){
        self.Title = title
        self.Value = value
    }
    
    @objc dynamic var Title : String!
    @objc dynamic var Value : NSObject!
}

class ComboView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var myView: UIView!
    @IBOutlet var pickerView: UIPickerView?
    //var pickerViewHelper: UIPickerView?
    
    @IBOutlet var btnMain: UIButton!
    @IBOutlet var txtTest: UITextField!
    
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var btnDone: UIBarButtonItem!
    @IBOutlet var btnCancel: UIBarButtonItem!
    
    @objc dynamic var defaultText : String = ""
    
    var delegate: ComboViewDelegate?
    
    
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = true
    
    var _dataSource : [ComboViewItem]=[ComboViewItem]() //= [ComboViewItem(title: "White", value: 1),
    var dataSource : [ComboViewItem] {
        get{
            return _dataSource
        }
        set(value){
            Threading.sync(self){
                self._dataSource = value
            }
        }
    }
    
    
//        ComboViewItem(title: "Red", value: 2),
//        ComboViewItem(title: "Green", value: 3),
//        ComboViewItem(title: "Blue", value: 4)] //["White", "Red", "Green", "Blue"];
//
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    
        
        Bundle.main.loadNibNamed("ComboView", owner: self, options: nil)

        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5

        self.toolbar=UIToolbar(frame: CGRect(x: 0,y: 0,width: 320,height: 44))
        self.toolbar.barStyle=UIBarStyle.blackOpaque
        self.txtTest=UITextField(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
     
    
        
        //self.myView.addConstraint(widthConstraint)
        
        self.pickerView=UIPickerView(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        //self.pickerViewHelper = self.pickerView
        self.btnDone = UIBarButtonItem(title: "Done", style:UIBarButtonItemStyle.plain, target: self, action: #selector(ComboView.doneClicked))
        self.btnCancel = UIBarButtonItem(title: "Cancel", style:UIBarButtonItemStyle.plain, target: self, action: #selector(ComboView.cancelClicked))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        self.toolbar.setItems([self.btnCancel, btnSpace, self.btnDone], animated: true)
        
        self.addSubview(myView)
        //self.myView.addSubview(self.toolbar)
        self.myView.addSubview(self.txtTest)
        self.txtTest.inputAccessoryView=self.toolbar
        
        //self.myView.frame=self.frame
        
        //print(self.frame.width)
        
        self.myView.frame=CGRect(x: 0,y: 0,width: self.frame.width,height: 44)
//        let toolbarHeightConstraint = NSLayoutConstraint(item: self.toolbar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 160)
//        self.toolbar.addConstraints([toolbarHeightConstraint])
        
       
        
        
        //self.toolbar.frame=CGRect(x: 0,y: 0,width: self.frame.width,height: 44)
        //let widthConstraint = NSLayoutConstraint(item: self.btnMain, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        //let widthConstraint = NSLayoutConstraint(item: self.btnMain, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        //let widthConstraint1 = NSLayoutConstraint(item: self.btnMain, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        
//        let widthConstraint = NSLayoutConstraint(item: self.myView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
//        let widthConstraint1 = NSLayoutConstraint(item: self.myView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
//        self.myView.addConstraints([toolbarHeightConstraint])

        //NSLayoutConstraint.ac
        //self.btnMain.backgroundColor=UIColor(displayP3Red: CGFloat(0.8), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0))
        
    }
    
//    public func setToolbarHidden(value:Bool){
//        self.toolbar..set.setHidden(value)
//    }
//
//    func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
//        print("rotation changed!")
//    }

    
    override func didAddSubview(_ subview: UIView) {
        
        self.pickerView!.showsSelectionIndicator=true
        
        self.pickerView!.dataSource = self
        self.pickerView!.delegate = self
        
        self.txtTest.inputView=self.pickerView
        btnMain.setTitle(self.defaultText, for: UIControlState())
    }
    
    @objc func doneClicked(){
        selectedIndex = pickerView!.selectedRow(inComponent: 0)
        if (selectedIndex >= 0){
            self.delegate?.comboViewChanged(selectedIndex, item: dataSource[selectedIndex])
        }
        else{
            self.delegate?.comboViewChanged(-1, item: nil)
        }
        self.txtTest.resignFirstResponder()
    }
    @objc func cancelClicked(){
        self.txtTest.resignFirstResponder()
    }
    
    @IBAction func comboToggle(_ sender: UIButton) {
        self.btnMain.resignFirstResponder()
        self.txtTest.becomeFirstResponder()
        let frame=self.pickerView!.frame;
        self.toolbar.frame=CGRect(x: 0,y: 0,width: frame.width,height: 44)
    }
    
    var _selectedIndex: Int = -1
    @objc dynamic var selectedIndex: Int {
        get{
            return _selectedIndex
        }
        set(value){
            var text = ""
            if (self.dataSource.count != 0){
                if (value >= self.dataSource.count){
                    self._selectedIndex = 0
                }
                else{
                    self._selectedIndex = value
                }
                if (_selectedIndex < 0) {
                    _selectedIndex = 0
                }
                self.pickerView!.selectRow(self._selectedIndex, inComponent: 0, animated: false)
                if (self.selectedIndex >= 0){
                    text =  self.dataSource[self.selectedIndex].Title
                }
            }
            defer{
                btnMain.setTitle(text, for: UIControlState())
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource.count;
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].Title
    }
    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let text = self.dataSource[row].Title
//        btnMain.setTitle(text, forState: .Normal)
//    }
    
}
