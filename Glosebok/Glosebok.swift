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
    var translatedWords: [[String]]
    var overallRating: Double = 0.0
    var ratingForEachWord: [Int] = [Int]()
    var smileys = [UIImage]()
    
    //MARK: Initialization
    init(title: String?, lang1: String, lang2: String){
        self.title = title!
        self.lang1 = lang1
        self.lang2 = lang2
        
        smileys.append(UIImage(named: "utterShit")!)
        smileys.append(UIImage(named: "prettyBad")!)
        smileys.append(UIImage(named: "prettyGood")!)
        smileys.append(UIImage(named: "complete")!)
        
        
        if title == ""{
         self.title = ("Min Glosebok " + String(GlosebokTableViewController.bookCounter))
            debugPrint("Adding one")
            GlosebokTableViewController.bookCounter+=1
        }
        
        wordsLang1 = []
        wordsLang2 = []
        glossary = [wordsLang1,wordsLang2]
        translatedWords = [[],[]]
        currentStatus = smileys[0]
        
    }
    
    //MARK: Functions
    func updateStatus(currentStatus: UIImage?){

        
        if currentStatus != nil{
            self.currentStatus = currentStatus!
        }
        
    }
    
    func updateRating(){
        let sum = ratingForEachWord.reduce(0, combine: +)
        overallRating = Double(sum) / Double(translatedWords[0].count+glossary[0].count)
        
        if overallRating <= 1{
            currentStatus = smileys[0]
        }else if overallRating <= 2{
            currentStatus = smileys[1]
        }else if overallRating <= 3{
            currentStatus = smileys[2]
        }else{
            currentStatus = smileys[3]
        }
    }
    func addNewWord(wordLang1: String, wordLang2: String){
        glossary[0].append(wordLang1)
        glossary[1].append(wordLang2)
    }
    
    
    func replaceWordInGlossary(replacementWord: String, index: Int, language: Int){
        glossary[language][index] = replacementWord

    }
    

    
}