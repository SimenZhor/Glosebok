//
//  SceneOnePracticeViewController.swift
//  glosebok
//
//  Created by Simen E. Sørensen on 05/02/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class SceneOnePracticeViewController: UIViewController, UITextFieldDelegate{
    
    //MARK: Properties
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var avbrytButton: UIBarButtonItem!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var fullførButton: UIButton!
    
    //Edit options
    @IBOutlet weak var bottomViewOnEdit: UIView!
    @IBOutlet weak var languageSwitch: UISwitch!
    @IBOutlet weak var languageSwitchLabel: UILabel!
    var bottomViewOnEditYConstraint: NSLayoutConstraint?
    var constraintToPushUpButtons: NSLayoutConstraint?

    
    
    var glosebok: Glosebok?
    var index = 0
    var langSwitched = false
    var initialSegue = false
    var prevRating = 0
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTextField.delegate = self
        
        
        if initialSegue{
            self.navigationController?.navigationBarHidden = true
            //wordsDone = [Int](count: glosebok!.glossary[0].count, repeatedValue: 0)
            wordLabel.text = glosebok?.glossary[0][0]
            initialSegue = false
        }else{
            //unwindToSceneOnePractice()
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutIfNeeded()
        hideLanguageSwitch(false) //animated = false
    }

    //MARK: Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === translateButton{
            let sceneTwoPracticeViewController = segue.destinationViewController as! SceneTwoPracticeViewController
            sceneTwoPracticeViewController.index = index
            debugPrint(glosebok!.glossary[1][index])
            sceneTwoPracticeViewController.glosebok = glosebok
            sceneTwoPracticeViewController.langSwitched = langSwitched
        }else if sender === avbrytButton{
            debugPrint("back pressed")
            cleanUpTranslatedWords()
            navigationController?.navigationBarHidden = false
            if langSwitched{
                languageSwitched(languageSwitch)
            }
        }
    }
    
    @IBAction func unwindToSceneOnePractice(sender: UIStoryboardSegue){
        
        //handle ratings
        debugPrint("rating = ", prevRating)
        if glosebok?.ratingForEachWord.count < glosebok?.glossary[0].count{
            glosebok?.ratingForEachWord.append(prevRating)
        }else{
            glosebok?.ratingForEachWord[index] = prevRating
        }
        glosebok?.updateRating()
        
        //handle which words we are done with (without creating a possible infinite for-loop with random index that has not yet been used)
        glosebok?.translatedWords[0].append((glosebok?.glossary[0][index])!)
        glosebok?.translatedWords[1].append((glosebok?.glossary[1][index])!)
        glosebok?.glossary[0].removeAtIndex(index)
        glosebok?.glossary[1].removeAtIndex(index)
        
        if glosebok!.glossary[0].count == 0{
            // if all words are done
            editButton.title = "Fullfør"
            wordLabel.text = "Du klarte det!"
            debugPrint("Average rating: ",glosebok?.overallRating)
            //possibility to print out average rating at runtime.
            ratingImageView.image = glosebok?.currentStatus
            ratingImageView.hidden = false
            fullførButton.hidden = false
            translateButton.hidden = true
            restartButton.hidden = false
        }else{
            //else find a random new word
            let word = glosebok!.glossary[0].randomItem()
            wordLabel.text = word
            index = glosebok!.glossary[0].indexOf(word)!
            
        }
        
    }
    
    func hideLanguageSwitch(animated: Bool){
        removeBottomViewOnEditYConstraint()
        let hideConstraint = NSLayoutConstraint(item: self.bottomViewOnEdit, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        self.bottomViewOnEditYConstraint = hideConstraint
        self.view.addConstraint(hideConstraint)
        
        self.performConstraintLayout(animated)
        
    }
    func showLanguageSwitch(animated: Bool){
        removeBottomViewOnEditYConstraint()
        let showConstraint = NSLayoutConstraint(item: self.bottomViewOnEdit, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        //let pushConstraint = NSLayoutConstraint(item: self.translateButton, attribute: .Bottom, relatedBy: .Height(33), toItem: self.bottomViewOnEdit, attribute: .Top, multiplier: 1, constant: 0)
        self.bottomViewOnEditYConstraint = showConstraint
        //self.constraintToPushUpButtons = pushConstraint
        self.view.addConstraint(showConstraint)
        //self.view.addConstraint(pushConstraint)
        
        self.performConstraintLayout(animated)
        
    }
    
    func performConstraintLayout(animated: Bool){
        if animated == true{
            UIView.animateWithDuration(0.5, animations: {() -> Void in self.view.layoutIfNeeded()})
            
        }else{
            self.view.layoutIfNeeded()
        }
    }
    
    func removeBottomViewOnEditYConstraint(){
        if bottomViewOnEditYConstraint != nil{
            self.view.removeConstraint(bottomViewOnEditYConstraint!)
            self.bottomViewOnEditYConstraint = nil
        }
    }
    //MARK: TextField Delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if wordTextField.text != ""{
            glosebok?.glossary[0][index] = wordTextField.text!
            wordLabel.text = glosebok?.glossary[0][index]
            wordTextField.hidden = true
            wordLabel.hidden = false
            
            translateButton.enabled = true
            editButton.title = "Edit"
            hideLanguageSwitch(true)
            /*UIView.animateWithDuration(0.5, animations: {
                self.bottomViewOnEdit.center.y += self.bottomViewOnEdit.bounds.height
                self.languageSwitch.center.y += self.bottomViewOnEdit.bounds.height
                self.languageSwitchLabel.center.y += self.bottomViewOnEdit.bounds.height})*/
        }else{
            translateButton.enabled = false
            wordTextField.text = glosebok?.glossary[0][index]
            wordTextField.becomeFirstResponder()
        }
    }
    
    func cleanUpTranslatedWords(){
        if glosebok?.translatedWords[0].count > 0{
            for var i = 0; i<glosebok?.translatedWords[0].count; i++ {
                glosebok?.glossary[0].append((glosebok?.translatedWords[0][i])!)
            }
            glosebok?.translatedWords[0].removeAll()
        }
        if glosebok?.translatedWords[1].count > 0{
            for var i = 0; i<glosebok?.translatedWords[1].count; i++ {
                glosebok?.glossary[1].append((glosebok?.translatedWords[1][i])!)
            }
            glosebok?.translatedWords[1].removeAll()
        }
    }
    
    //MARK: Actions
    
    @IBAction func restartButtonAction(sender: UIButton) {
        glosebok!.glossary = glosebok!.translatedWords
        glosebok?.translatedWords = [[],[]]
        let word = glosebok!.glossary[0].randomItem()
        wordLabel.text = word
        index = glosebok!.glossary[0].indexOf(word)!
        translateButton.hidden = false
        restartButton.hidden = true
        editButton.enabled = true
        fullførButton.hidden = true
        ratingImageView.hidden = true
        editButton.title = "Edit"
    }
    
    @IBAction func editWord(sender: UIBarButtonItem) {
        if editButton.title == "Edit"{
            wordTextField.text = wordLabel.text
            wordLabel.hidden = true
            wordTextField.hidden = false
            translateButton.enabled = false
            view.layoutIfNeeded()
            
            showLanguageSwitch(true)
            editButton.title = "Done"
        }else if editButton.title == "Done"{
            if wordTextField.isFirstResponder(){
                textFieldShouldReturn(wordTextField)
                //wordTextField.resignFirstResponder()
            }else{
                wordTextField.becomeFirstResponder()
                textFieldShouldReturn(wordTextField)
            }
        }
        else if editButton.title == "Fullfør"{
            performSegueWithIdentifier("EndPractice", sender: avbrytButton)
        }
    }
    
    @IBAction func languageSwitched(sender: UISwitch) {
        // flips the order of language arrays in glosebok
        if wordTextField.isFirstResponder(){
            wordTextField.resignFirstResponder()
        }
        var langArray0 = glosebok?.glossary[0]
        var langArray1 = glosebok?.glossary[1]
        glosebok?.glossary[0] = langArray1!
        glosebok?.glossary[1] = langArray0!
        
        //flips the languages in glossary (not visible at runtime)
        let lang1 = glosebok?.lang1
        let lang2 = glosebok?.lang2
        debugPrint("Switch initiated: ",lang1," -> ",lang2," & vice versa")
        glosebok?.lang1 = lang2!
        glosebok?.lang2 = lang1!
        
        if glosebok?.translatedWords[0].count > 0{
            //flips translated words if needed.
            langArray0 = glosebok?.translatedWords[0]
            langArray1 = glosebok?.translatedWords[1]
            glosebok?.translatedWords[0] = langArray1!
            glosebok?.translatedWords[1] = langArray0!
        }
        
        //WARNING: Will reset when practice is done. Want to make permanent? If yes: change langSwitched to false and languageswitch.setOn(false, anim: true)
        
        //flips the boolean that checks if languages need to be switched back at startup
        if languageSwitch.on == true{
            //language has been switched
            langSwitched = true
            
        }else{
            //language has been switched back to its original state
            langSwitched = false
        }
        
        //update view
        wordLabel.text = glosebok?.glossary[0][index]
        wordTextField.text = glosebok?.glossary[0][index]
    }

    
    
    @IBAction func avbrytButtonAction(sender: UIBarButtonItem) {
        performSegueWithIdentifier("EndPractice", sender: sender)
    }
    @IBAction func fullførButtonAction(sender: UIButton) {
        avbrytButtonAction(avbrytButton)
    }
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
