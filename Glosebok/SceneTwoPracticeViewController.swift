//
//  SceneTwoPracticeViewController.swift
//  glosebok
//
//  Created by Simen E. Sørensen on 05/02/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class SceneTwoPracticeViewController: UIViewController, RatingControlDelegate {
    
    //MARK: Properties
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    //var wordsDone: [Int] = []
    var rating = 0
    var index = 0
    var glosebok: Glosebok?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        wordLabel.text = glosebok?.glossary[1][index]
        ratingControl.delegate = self
    }
    
    func recieveRating(rating: Int) {
        self.rating = rating
        performSegueWithIdentifier("RatingDone", sender: ratingControl)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === ratingControl{
            let sceneOne = segue.destinationViewController as! SceneOnePracticeViewController
            sceneOne.prevRating = rating
            sceneOne.glosebok = glosebok
            //sceneOne.wordsDone = wordsDone
            //glosebok?.glossary[1].removeAtIndex(index)
        }
    }

}
