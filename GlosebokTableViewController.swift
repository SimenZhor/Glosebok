//
//  GlosebokTableViewController.swift
//  Glosebok
//
//  Created by Simen E. Sørensen on 31/01/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class GlosebokTableViewController: UITableViewController{

    
    //MARK Properties
    var library = [Glosebok]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Loading saved library from NSUserDefaults
        load()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
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
        cell.completionImage.image = glosebok.currentStatus
        
        cell.keywordsLabel.text = keywords
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            
            library.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
            
        } /*else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
        self.save()
    }


    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

        let movedGlossary = library[fromIndexPath.row]
        
        library.removeAtIndex(fromIndexPath.row)
        library.insert(movedGlossary, atIndex: toIndexPath.row)
        //if the glossary is moved down the list we don't want to change the indexing before moving it. EDIT: this is apparently already handled before sending indexpaths to this function. Removed this if-test
      
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
            
        }
        
        let moreClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.performSegueWithIdentifier("AddWordsToItem", sender: self.tableView.cellForRowAtIndexPath(indexPath))
            print("More closure called")
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Slett", handler: deleteClosure)
        let moreAction = UITableViewRowAction(style: .Normal, title: "Legg til ord", handler: moreClosure)
        
        moreAction.backgroundColor = UIColor.lightGrayColor()
        
        return [deleteAction, moreAction]
    }

    
    

    
    
    //MARK: - Functions
    
    func save(){
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(library)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "library")
    }
    func load(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let savedLibrary = defaults.objectForKey("library") as? NSData{
            self.library = NSKeyedUnarchiver.unarchiveObjectWithData(savedLibrary) as! [Glosebok]
        }
    }
    
    func addWordsAction(){
        debugPrint("Add words tapped")
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddItem"{
            debugPrint("Initializing new Glosebok")            
        }
        else if segue.identifier == "StartPractice"{
            let sceneOnePracticeViewController = segue.destinationViewController as! SceneOnePracticeViewController
            if let selectedGlossaryCell = sender as? GlosebokTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedGlossaryCell)!
                let selectedGlosebok = library[indexPath.row]
                selectedGlosebok.ratingForEachWord.removeAll()
                sceneOnePracticeViewController.glosebok = selectedGlosebok
                //sceneOnePracticeViewController.counter = 0
                sceneOnePracticeViewController.initialSegue = true
            }
        }else if segue.identifier == "AddWordsToItem"{
            let destVC = segue.destinationViewController as! AddWordsTableViewController
            if let selectedGlossaryCell = sender as? GlosebokTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedGlossaryCell)!
                let selectedGlosebok = library[indexPath.row]
                destVC.glosebok = selectedGlosebok
                destVC.newGlossary = false
            }
            
        }
        self.save()
    }


    @IBAction func unwindToGlosebokList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.sourceViewController as? AddWordsTableViewController {
            //glosebok = sourceViewController.glosebok
            let glosebok = sourceViewController.glosebok
            //Add a new glosebok
            if !sourceViewController.newGlossary{
                let row = library.indexOf(glosebok!)
                let selectedIndexPath = NSIndexPath(forRow: row!, inSection: 0)
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                sourceViewController.newGlossary = true
            }else{
                
                let newIndexPath = NSIndexPath(forRow: library.count, inSection: 0)
                library.insert(glosebok!, atIndex: 0)
                //library.append(glosebok!)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        } else if let sourceViewController = sender.sourceViewController as? SceneOnePracticeViewController{
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let glosebok = sourceViewController.glosebok
            library[selectedIndexPath!.row] = glosebok!
            
            tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: .None)
            
        }
        tableView.reloadData()
        self.save()
        
    }

}
