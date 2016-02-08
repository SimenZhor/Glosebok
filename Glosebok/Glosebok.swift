//
//  Glosebok.swift
//  Glosebok
//
//  Created by Simen E. Sørensen on 31/01/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class Glosebok: NSObject, NSCoding{
    
    //MARK: Properties

    var title: String
    var lang1: String
    var lang2: String
    
    var currentStatus: UIImage
    var glossary: [[String]] //glossary = [wordsLang1,wordsLang2]
    var translatedWords: [[String]]
    var overallRating: Double = 0.0
    var ratingForEachWord: [Int] = [Int]()
    var smileys = [UIImage]()
    
    //MARK: Types
    
    struct PropertyKey {
        static let titleKey = "title"
        static let lang1Key = "lang1"
        static let lang2Key = "lang2"
        static let currentStatusKey = "currentStatus"
        static let glossaryKey = "glossary"
        static let avgRatingKey = "avgRating"
        static let ratingEachWordKey = "ratingForEachWord"
        static let smileysKey = "smileys"
        
    }
    
    //MARK: Initialization
    init(title: String?, lang1: String, lang2: String){
        self.title = title!
        self.lang1 = lang1
        self.lang2 = lang2
        
        smileys.append(UIImage(named: "utterShit")!)
        smileys.append(UIImage(named: "prettyBad")!)
        smileys.append(UIImage(named: "prettyGood")!)
        smileys.append(UIImage(named: "complete")!)
        
        self.currentStatus = smileys[0]
        
        self.glossary = [[],[]]
        self.translatedWords = [[],[]]
        
        
        
        if title == ""{
         self.title = ("Min Glosebok " + String(GlosebokTableViewController.bookCounter))
            debugPrint("Adding one")
            GlosebokTableViewController.bookCounter+=1
        }
        
    }
    /*
    convenience init?(title: String, lang1: String, lang2: String, currentStatus: UIImage, glossary: [[String]], overallRating: Double?, ratingForEachWord: [Int]?){
        self.title = title
        self.lang1 = lang1
        self.lang2 = lang2
        self.currentStatus = currentStatus
        self.glossary = glossary

        
        if overallRating != nil{
            self.overallRating = overallRating!
        }
        if ratingForEachWord != nil{
            self.ratingForEachWord = ratingForEachWord!
        }
        
        translatedWords = [[],[]]
        
        self.init(title: title, lang1: lang1, lang2: lang2)
    }*/

    
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
    
    //MARK: NSCoding
    
    /*
    let titleKey = "title"
    let lang1Key = "lang1"
    let lang2Key = "lang2"
    let currentStatusKey = "currentStatus"
    let glossaryKey = "glossary"
    let avgRatingKey = "avgRating"
    let ratingEachWordKey = "ratingForEachWord"
    let smileysKey = "smileys"*/

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(lang1, forKey: PropertyKey.lang1Key)
        aCoder.encodeObject(lang2, forKey: PropertyKey.lang2Key)
        aCoder.encodeObject(currentStatus, forKey: PropertyKey.currentStatusKey)
        aCoder.encodeDouble(overallRating, forKey: PropertyKey.avgRatingKey)
        
        aCoder.encodeObject(glossary, forKey: PropertyKey.glossaryKey)
        aCoder.encodeObject(ratingForEachWord, forKey: PropertyKey.ratingEachWordKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let lang1 = aDecoder.decodeObjectForKey(PropertyKey.lang1Key) as! String
        let lang2 = aDecoder.decodeObjectForKey(PropertyKey.lang2Key) as! String
        
        self.init(title: title, lang1: lang1, lang2: lang2)
       
        self.currentStatus = aDecoder.decodeObjectForKey(PropertyKey.currentStatusKey) as! UIImage
        self.overallRating = aDecoder.decodeDoubleForKey(PropertyKey.avgRatingKey)
        self.glossary = aDecoder.decodeObjectForKey(PropertyKey.glossaryKey) as! [[String]]
        self.ratingForEachWord = aDecoder.decodeObjectForKey(PropertyKey.ratingEachWordKey) as! [Int]
    }
    
}