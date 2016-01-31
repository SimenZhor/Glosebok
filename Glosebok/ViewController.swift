//
//  ViewController.swift
//  Glosebok
//
//  Created by Simen E. Sørensen on 25/01/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    //MARK: Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var lang1Label: UILabel!
    @IBOutlet weak var lang2Label: UILabel!
    
    //MARK: Variables
    var languageList: [String] = [String]()
    var pickerData: [[String]] = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks
        titleTextField.delegate = self
        
        //Handle Picker's user input through delegate callbacks
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        //Input languages into the Array:
        pickerData = [["Norsk", "Russisk", "Engelsk", "Spansk"],["Norsk", "Russisk", "Engelsk", "Spansk"]]
        languageList = updatePickerViewLanguages()
        pickerData = [languageList,languageList]

    }

    //MARK: Actions

    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        titleLabel.text = textField.text
        
    }
    
    //MARK: UIPickerViewDelegate
        //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int{
        return pickerData[component].count
    }
    
        //MARK: Delegates
    func pickerView(pickerView:UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            lang1Label.text = pickerData[0][languagePicker.selectedRowInComponent(0)]
            lang2Label.text = pickerData[1][languagePicker.selectedRowInComponent(1)]
        }



    //MARK: Functions
    func updatePickerViewLanguages() -> [String]{
        var languages: [String] = NSLocale.preferredLanguages()
        
        for var row = 0; row < languages.count; row++ {
            let languageCode: String = NSLocale.preferredLanguages()[row]
            let locale: NSLocale = NSLocale(localeIdentifier: languageCode)
            languages[row] = locale.displayNameForKey(NSLocaleIdentifier, value: languageCode)!
            //remove specific language version
            languages[row] = removeParanthesisAtEndOfString(languages[row])
            //capitalize languages
            languages[row] = languages[row].capitalizedString
            }
        return languages
    }
    
    func removeParanthesisAtEndOfString(var string: String) -> String{
        // attempting to remove any parentheses at the end of the string
        if string.hasSuffix(")"){
            //removes removes characters until the last char is (
            repeat{
                string.removeAtIndex(string.endIndex.predecessor())
            }while string.hasSuffix("(") == false
            //removes the ( as well
            string.removeAtIndex(string.endIndex.predecessor())
        }
        return string
    }

}

