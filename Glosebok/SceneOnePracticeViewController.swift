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
    
    
    var glosebok: Glosebok?
    //var wordsDone: [Int] = []
    var index = 0
    //var counter = 0
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

    //MARK: Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === translateButton{
            let sceneTwoPracticeViewController = segue.destinationViewController as! SceneTwoPracticeViewController
            sceneTwoPracticeViewController.index = index
            debugPrint(glosebok!.glossary[1][index])
            sceneTwoPracticeViewController.glosebok = glosebok
            //sceneTwoPracticeViewController.wordsDone = wordsDone
        }else if sender === avbrytButton{
            debugPrint("back pressed")
            cleanUpTranslatedWords()
            navigationController?.navigationBarHidden = false
            //performSegueWithIdentifier("EndPractice", sender: avbrytButton)
        }
    }
    
    @IBAction func unwindToSceneOnePractice(sender: UIStoryboardSegue){
        //wordsDone[counter] = index
        //counter++
        debugPrint("rating = ", prevRating)
        glosebok?.ratingForEachWord.append(prevRating)
        glosebok?.updateRating()
        glosebok?.translatedWords[0].append((glosebok?.glossary[0][index])!)
        glosebok?.translatedWords[1].append((glosebok?.glossary[1][index])!)
        glosebok?.glossary[0].removeAtIndex(index)
        glosebok?.glossary[1].removeAtIndex(index)
        if glosebok!.glossary[0].count == 0{
            editButton.title = "Fullfør"
            wordLabel.text = "Du klarte det!"
            //Sett inn smilefjes her
            translateButton.hidden = true
            restartButton.hidden = false
        }
        if glosebok!.glossary[0].count > 0{
            let word = glosebok!.glossary[0].randomItem()
            wordLabel.text = word
            index = glosebok!.glossary[0].indexOf(word)!
            
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
    }
    
    @IBAction func editWord(sender: UIBarButtonItem) {
        if editButton.title == "Edit"{
            wordTextField.text = wordLabel.text
            wordTextField.hidden = false
            wordTextField.becomeFirstResponder()
            wordLabel.hidden = true
            editButton.title = "Done"
        }else if editButton.title == "Done"{
            textFieldShouldReturn(wordTextField)
            //wordTextField.resignFirstResponder()
            
        }
        else if editButton.title == "Fullfør"{
            performSegueWithIdentifier("EndPractice", sender: avbrytButton)
        }
    }
    @IBAction func avbrytButtonAction(sender: UIBarButtonItem) {
        performSegueWithIdentifier("EndPractice", sender: sender)
    }
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
