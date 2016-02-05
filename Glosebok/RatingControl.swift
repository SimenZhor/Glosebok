//
//  RatingControl.swift
//  glosebok
//
//  Created by Simen E. Sørensen on 05/02/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class RatingControl: UIView, RatingControlView {

    //MARK: Properties
    weak var delegate: RatingControlDelegate?
    var rating = 0
    var ratingButtons = [UIButton]()
    var spacing = 5
    var smileys = [UIImage]()
    


    
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        smileys.append(UIImage(named: "utterShit")!)
        smileys.append(UIImage(named: "prettyBad")!)
        smileys.append(UIImage(named: "prettyGood")!)
        smileys.append(UIImage(named: "complete")!)
        
        for index: Int in 0..<smileys.count{
            let button = UIButton()
            button.setImage(smileys[index], forState: .Normal)
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchUpInside)
            ratingButtons += [button]
            addSubview(button)
        }
        
    }
    
    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        //Offset each buttons origin with the button width plus spacing
        for (index,button) in ratingButtons.enumerate(){
            buttonFrame.origin.x = CGFloat(index * (buttonSize+5))
            button.frame = buttonFrame
        }
    }

    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * smileys.count
        
        return CGSize(width: width, height: buttonSize)
    }
    
    //MARK: Button Action
    func ratingButtonTapped(button: UIButton){
        rating = ratingButtons.indexOf(button)! + 1
        debugPrint("rating = ", rating)
    }
}
