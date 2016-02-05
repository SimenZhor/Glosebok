//
//  CellDelegate.swift
//  Glosebok
//
//  Created by Simen E. Sørensen on 04/02/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

@objc protocol AddOneWordToGlossaryCell{
   
    func didEditFirstTextField()
    func didEditSecondTextField()
  
}

protocol AddOneWordToGlossaryCellDelegate: class{
    
    func wordAdded(language: Int, word: String)
    func wordEdited(language: Int, index: Int, word: String)

    func expandTableViewWithOneCell(indexPath: NSIndexPath, language: Int, word: String)
    func textFieldEdited(sender: AddWordTableViewCell, word: String, language: Int)
    
}
