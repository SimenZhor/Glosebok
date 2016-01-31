//
//  GlosebokTableViewController.swift
//  Glosebok
//
//  Created by Simen E. Sørensen on 31/01/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class GlosebokTableViewController: UITableViewController {

    
    //MARK Properties
    var library = [Glosebok]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading sample data
        loadSamples()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadSamples(){
        
        let glossary1 = Glosebok(title: "Bok1", lang1: "Norwegian", lang2: "English")
        let glossary2 = Glosebok(title: "Bok2", lang1: "English", lang2: "Russian")
        let glossary3 = Glosebok(title: "bok3", lang1: "English", lang2: "Norwegian")
        
        library += [glossary1, glossary2, glossary3]
        
        library[0].addNewWord("Hei", wordLang2: "Hello")
        library[0].addNewWord("Drittsekkfaen", wordLang2: "Wow, thats a long word")
        library[0].addNewWord("Langt ord", wordLang2: "Thats not even a word")
        library[0].addNewWord("Det får værra nok nå eller?!", wordLang2: "yep")
        
    }
    
    func getLibrary() -> [Glosebok]{
        return self.library
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "GlosebokTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GlosebokTableViewCell
        
        //Fetches appropriate glosebok for this cell
        let glosebok = library[indexPath.row]
        
        //Applies values from glosebok to the cell 
        cell.titleLabel.text = glosebok.title
        cell.languageLabel.text = glosebok.lang1+" - "+glosebok.lang2
        
        var keywords: String = ""
        
        for var index = 0; index < glosebok.glossary[0].count; index++ {
            
            if index < 3 {
                keywords += (glosebok.glossary[0][index] + ", ")
            }
        }
        if keywords.isEmpty == false{
            keywords.removeAtIndex(keywords.endIndex.predecessor())
            keywords.removeAtIndex(keywords.endIndex.predecessor()) //removes last comma
        }
        
        cell.keywordsLabel.text = keywords
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
