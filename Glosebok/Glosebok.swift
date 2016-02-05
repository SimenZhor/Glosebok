//
//  Glosebok.swift
//  Glosebok
//
//  Created by Simen E. Sørensen on 31/01/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class Glosebok{
    
    //MARK: Properties

    var title: String
    var lang1: String
    var lang2: String
    
    var currentStatus: UIImage
    var wordsLang1: [String]
    var wordsLang2: [String]
    var glossary: [[String]] //glossary = [wordsLang1,wordsLang2]
    

    
    //MARK: Initialization
    init(title: String?, lang1: String, lang2: String){
        self.title = title!
        self.lang1 = lang1
        self.lang2 = lang2
        
        if title == ""{
         self.title = "Ny Glosebok " //+ (GlosebokTableViewController.getLibrary().count + 1) //Library = array med alle glosebøker
        }
        
        wordsLang1 = []
        wordsLang2 = []
        glossary = [wordsLang1,wordsLang2]
        currentStatus = UIImage(named:"utterShit")!
        
    }
    
    //Soft initialization of the words in the glossary
    func initGlossary(wordsLang1:[String], wordsLang2: [String]){
        
        self.wordsLang1 = wordsLang1
        self.wordsLang2 = wordsLang2
        updateGlossary()
        
    }
    //MARK: Functions
    func updateStatus(currentStatus: UIImage?){
        
        if currentStatus != nil{
            self.currentStatus = currentStatus!
        }
        
    }
    
    func updateGlossary(){
        self.glossary = [self.wordsLang1, self.wordsLang2]
    }
    
    func replaceWordInGlossary(replacementWord: String, index: Int, language: Int){
        
        if language == 1{
            wordsLang1[index] = replacementWord
        }else if language == 2{
            wordsLang2[index] = replacementWord
        }else{
            print("Invalid language")
        }
        
        updateGlossary()
    }
    
    func addNewWord(wordLang1: String, wordLang2:String){
        self.wordsLang1.append(wordLang1)
        self.wordsLang2.append(wordLang2)
        updateGlossary()
    }
    
}