//
//  ComboView.swift
//  Restroom
//
//  Created by DevTeam on 2/1/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit

protocol ComboViewDelegate: class{
    func comboViewChanged(selectedIndex: Int, item:ComboViewItem!)
}

class ComboViewItem{
    init(title:String, value:NSObject!){
        self.Title = title
        self.Value = value
    }
    
    dynamic var Title : String!
    dynamic var Value : NSObject!
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
    
    dynamic var defaultText : String = ""
    
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
        
        NSBundle.mainBundle().loadNibNamed("ComboView", owner: self, options: nil)

        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5

        self.toolbar=UIToolbar(frame: CGRectMake(0,0,320,44))
        self.toolbar.barStyle=UIBarStyle.BlackOpaque
        self.txtTest=UITextField(frame: CGRectMake(0,0,0,0))

        self.pickerView=UIPickerView(frame: CGRectMake(0,0,0,0))
        //self.pickerViewHelper = self.pickerView
        self.btnDone = UIBarButtonItem(title: "Done", style:UIBarButtonItemStyle.Plain, target: self, action: #selector(ComboView.doneClicked))
        self.btnCancel = UIBarButtonItem(title: "Cancel", style:UIBarButtonItemStyle.Plain, target: self, action: #selector(ComboView.cancelClicked))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        self.toolbar.setItems([self.btnCancel, btnSpace, self.btnDone], animated: true)
        
        self.addSubview(myView)
        //self.myView.addSubview(self.toolbar)
        self.myView.addSubview(self.txtTest)
        self.txtTest.inputAccessoryView=self.toolbar

    }
    
    override func didAddSubview(subview: UIView) {
        
        self.pickerView!.showsSelectionIndicator=true
        
        self.pickerView!.dataSource = self
        self.pickerView!.delegate = self
        
        self.txtTest.inputView=self.pickerView
        btnMain.setTitle(self.defaultText, forState: .Normal)
    }
    
    func doneClicked(){
        selectedIndex = pickerView!.selectedRowInComponent(0)
        if (selectedIndex >= 0){
            self.delegate?.comboViewChanged(selectedIndex, item: dataSource[selectedIndex])
        }
        else{
            self.delegate?.comboViewChanged(-1, item: nil)
        }
        self.txtTest.resignFirstResponder()
    }
    func cancelClicked(){
        self.txtTest.resignFirstResponder()
    }
    
    @IBAction func comboToggle(sender: UIButton) {
        self.btnMain.resignFirstResponder()
        self.txtTest.becomeFirstResponder()
        let frame=self.pickerView!.frame;
        self.toolbar.frame=CGRectMake(0,0,frame.width,44)
    }
    
    var _selectedIndex: Int = -1
    dynamic var selectedIndex: Int {
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
                btnMain.setTitle(text, forState: .Normal)
            }
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource.count;
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].Title
    }
    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let text = self.dataSource[row].Title
//        btnMain.setTitle(text, forState: .Normal)
//    }
    
}