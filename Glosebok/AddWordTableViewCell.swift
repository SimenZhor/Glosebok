//
//  AddWordTableViewCell.swift
//  Glosebok
//
//  Created by Simen E. Sørensen on 01/02/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class AddWordTableViewCell: UITableViewCell, UITextFieldDelegate, AddOneWordToGlossaryCell{

    //MARK: Outlets & Properties
    @IBOutlet weak var lang1TextField: UITextField!
    @IBOutlet weak var lang2TextField: UITextField!

    
    //Properties:
    weak var delegate: AddOneWordToGlossaryCellDelegate?
    var wordInLang1: String = ""
    var wordInLang2: String = ""
    var textBeforeEdit: String = ""
    
    var normalFont: UIFont = UIFont.systemFontOfSize(14)
    var normalBorderStyle: UITextBorderStyle = UITextBorderStyle.RoundedRect
    var normalTextAlignment: NSTextAlignment = NSTextAlignment.Natural
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lang1TextField.delegate = self
        lang2TextField.delegate = self
        
        normalFont = lang1TextField.font!
        normalBorderStyle = lang2TextField.borderStyle
        normalTextAlignment = lang2TextField.textAlignment
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: AddOneWordToGlossaryCell Delegates:
    
    func didEditFirstTextField() {
        debugPrint("dideditfirsttextfield was called")
        wordInLang1 = lang1TextField.text!
        delegate?.textFieldEdited(self, word: wordInLang1, language: 0)
    }
    
    func didEditSecondTextField() {
        debugPrint("dideditSecondtextfield was called")
        wordInLang2 = lang2TextField.text!
        delegate?.textFieldEdited(self, word: wordInLang2 , language: 1)
    }
    
    
    
    //MARK: TextField Delegates:
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        debugPrint("text field did end editing")
        if textField.text != ""{
            setTextFieldToBoldAppearance(textField)
        }
        if textField.text != textBeforeEdit{
            //initiates delegate task
            if textField === lang1TextField{
                debugPrint("first language was edited")
                didEditFirstTextField()
            } else if textField === lang2TextField{
                debugPrint("second language was edited")
                didEditSecondTextField()
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textBeforeEdit = textField.text!
        
        setTextFieldToNormalAppearance(textField)
    }

    func setTextFieldToNormalAppearance(textField: UITextField){
        //resets textField appearance to not containing a word
        textField.borderStyle = normalBorderStyle
        textField.textAlignment = normalTextAlignment
        textField.font = normalFont
    }
    func setTextFieldToBoldAppearance(textField: UITextField){
        //changes textField appearance to containing a word
        textField.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        textField.textAlignment = .Center
        textField.borderStyle = UITextBorderStyle.None
    }
}
