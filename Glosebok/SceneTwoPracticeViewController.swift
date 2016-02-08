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
    var langSwitched = false
    var rating = 0
    var index = 0
    var glosebok: Glosebok?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordLabel.text = glosebok?.glossary[1][index]
        ratingControl.delegate = self
    }
    
    func recieveRating(rating: Int) {
        self.rating = rating
        //unwind to scene one (via exit)
        performSegueWithIdentifier("RatingDone", sender: ratingControl)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === ratingControl{
            let sceneOne = segue.destinationViewController as! SceneOnePracticeViewController
            sceneOne.prevRating = rating
            sceneOne.glosebok = glosebok
            sceneOne.langSwitched = langSwitched
        }
    }

}
