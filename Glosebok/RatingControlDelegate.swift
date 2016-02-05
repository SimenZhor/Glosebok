//
//  RatingControlDelegate.swift
//  glosebok
//
//  Created by Simen E. Sørensen on 05/02/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import Foundation

protocol RatingControlView{
    
}

protocol RatingControlDelegate: class{
    func recieveRating(rating: Int)
}