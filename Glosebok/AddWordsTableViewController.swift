//
//  AddWordsTableViewController.swift
//  Glosebok
//
//  Created by Simen E. Sørensen on 01/02/16.
//  Copyright © 2016 Simen E. Sørensen. All rights reserved.
//

import UIKit

class AddWordsTableViewController: UITableViewController, AddOneWordToGlossaryCellDelegate {
    
    //MARK: Properties
    //@IBOutlet weak var cancelBarButton: UIBarButtonItem!
    //@IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem?
    
    
    var glosebok: Glosebok?
    var lang1: String = ""
    var lang2: String = ""
    
    var newGlossary = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // The following lines are examples of syntax for barbuttons
       // self.navigationItem.backBarButtonItem = nil
       
        self.backButton = self.navigationItem.backBarButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //self.navigationItem.backBarButtonItem!.action = "unwindToNewGlosebokController:"
        
        
        //self.editBarButton = self.editButtonItem()
        lang1 = glosebok!.lang1
        lang2 = glosebok!.lang2
        
        tableView.reloadData()
        updateDoneButton()
        
        
        //loadSampleGlossary()
        
    }
    
    /*
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent != self.parentViewController{
            debugPrint("testingkjlh")
            let test = self.navigationController?.parentViewController as! NewGlossaryViewController
            test.unwindToNewGlosebokController(UIStoryboardSegue(identifier: "UnwindToCreateGlossary", source: self, destination: test))
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return glosebok!.glossary[0].count + 1
    }

    

    
    //MARK: TableViewControllers
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AddWordTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AddWordTableViewCell

        cell.delegate = self
        cell.lang1TextField.placeholder = glosebok!.lang1
        cell.lang2TextField.placeholder = glosebok!.lang2
        // Fetches appropriate word-lists for this cell
        //if indexPath.row != 0{
            if indexPath.row < glosebok!.glossary[0].count{
                cell.setTextFieldToBoldAppearance(cell.lang1TextField)
                cell.lang1TextField.text = glosebok!.glossary[0][indexPath.row]
            }
            if indexPath.row < glosebok!.glossary[1].count{
                cell.setTextFieldToBoldAppearance(cell.lang2TextField)
                cell.lang2TextField.text = glosebok!.glossary[1][indexPath.row]
            }
        //}
        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete && glosebok?.glossary[0].count > 0{
            tableView.beginUpdates()
            
            if indexPath.row < glosebok!.glossary[0].count{
                //Checking that indexes are valid
                glosebok!.glossary[0].removeAtIndex(indexPath.row)
                glosebok!.glossary[1].removeAtIndex(indexPath.row)
            
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        } else if indexPath.row == 0{
            //create warningmessage "can't delete last row"
        }
        
        /*else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }   */ 
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if fromIndexPath != toIndexPath{
            let movedWord = [glosebok?.glossary[0][fromIndexPath.row],glosebok?.glossary[1][fromIndexPath.row]]
            glosebok?.glossary[0].removeAtIndex(fromIndexPath.row)
            glosebok?.glossary[1].removeAtIndex(fromIndexPath.row)
            glosebok?.glossary[0].insert(movedWord[0]!, atIndex: toIndexPath.row)
            glosebok?.glossary[1].insert(movedWord[1]!, atIndex: toIndexPath.row)
        }
    }


    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    //MARK: Actions
    
    @IBAction func backButtonAction(){
        performSegueWithIdentifier("BackToCreateGlossary", sender: backButton)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if doneButton === sender{
            debugPrint("lang1 count: ",glosebok!.glossary[0].count)
            debugPrint("lang2 count: ",glosebok!.glossary[1].count)
        
            // Pass the selected object to the new view controller.
        }
        debugPrint("Destination ",segue.destinationViewController)
        if let destVC = segue.destinationViewController as? NewGlossaryViewController{
            debugPrint("OH, my god")
        }
    }
    
    
    //MARK: Delegates from TableViewCell
    
    func wordAdded(language: Int, word: String) {
        debugPrint("added word ",word," at index: ",index," of language: ",language)
        glosebok!.glossary[language].append(word)
    }

    func wordEdited(language: Int, index: Int, word: String) {
        debugPrint("edited word ",word," at index: ",index," of language: ",language)
        glosebok!.glossary[language][index] = word
    }
    
    func expandTableViewWithOneCell(indexPath: NSIndexPath, language: Int, word: String) {
        //expand
        wordAdded(language, word: word)
        let newIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
        debugPrint("expanding")
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
    }
    
    func textFieldEdited(sender: AddWordTableViewCell, word: String, language: Int) {
        debugPrint("textFieldEdited method was called")
        //check for appropriate action
        let indexPath = tableView.indexPathForCell(sender)
        let index = indexPath?.row
        
       
        
        // if word is new
        if glosebok!.glossary[language].count <= index{
            debugPrint("new word found")
            if word == ""{
                // if word is nil
                // do nothing
                debugPrint("word is nil")
            }else{
                if isFirstWordWithIndex(index!){
                    debugPrint("word is the first at index: ",index)
                    //if a new cell needs to be created
                    expandTableViewWithOneCell(indexPath!, language: language, word: word)
                }else{
                    debugPrint("word added")
                    wordAdded(language, word: word)
                }
            }
        }
        
        //if word is edited
        else if glosebok!.glossary[language].count > index{
            debugPrint("glosebok is edited")
            if word == ""{
                // if word is nil
                debugPrint("word was nil and removed at index ",index)
                glosebok!.glossary[language].removeAtIndex(index!)
            }else{
                debugPrint("word was edited to ",word," at index: ",index)
                wordEdited(language, index: index!, word: word)
            }
        }
        
    }

    func isFirstWordWithIndex(index: Int) -> Bool{
        if glosebok!.glossary[0].count > glosebok!.glossary[1].count{
            //language 1 is largest array
            if glosebok!.glossary[0].count > index{
                //word is not first with index
                return false
            }else{
                return true
            }
            
        }else{
            //language 2 is largest array
            if glosebok!.glossary[1].count > index{
                //word is not first with index
                return false
            }else{
                return true
            }
        }
    }


    func updateDoneButton() {
        if glosebok!.glossary[0].count == glosebok!.glossary[1].count {
            doneButton.enabled = true
        }else{
            doneButton.enabled = false
        }
    }

    //MARK: Actions
    
    @IBAction func doneButtonAction(){
        performSegueWithIdentifier("UnwindToMain", sender: doneButton)
        
    }



}
