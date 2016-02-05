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
    @IBOutlet weak var ratingControl: RatingControl!
    var rating = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ratingControl.delegate = self
    }
    
    func recieveRating(rating: Int) {
        self.rating = rating
    }

}
