//
//  FirstViewController.swift
//  MyToDOList
//
//  Created by Matthew Ashley on 9/3/16.
//  Copyright © 2016 Matthew Ashley. All rights reserved.
//

import UIKit
import CloudKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet var tblTask: UITableView!
    @IBOutlet weak var customSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let filemgr = NSFileManager.defaultManager()
        let databaseName = "Tasks.db"
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0]
        
        let databasePath = docsDir.stringByAppendingPathComponent(databaseName)
        
        let taskDB = FMDatabase(path: databasePath as String)
        
        if filemgr.fileExistsAtPath(databasePath as String) {
            
            if taskDB == nil {
                
                print("Error: \(taskDB.lastErrorMessage())")
                
            }
            
            if taskDB.open() {
                
                let sql_stmt = "CREATE TABLE IF NOT EXISTS SAVETASK (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT(100), DESC TEXT(100), GRP TEXT(100))"
                
                if !taskDB.executeStatements(sql_stmt) {
                    
                    print("Error: \(taskDB.lastErrorMessage())")
                    
                }
                
            }else {
                print("Error: \(taskDB.lastErrorMessage())")
            }
            
        }

        if taskDB.open() {
            
                let querySQL = "SELECT * FROM SAVETASK"
            
                let results:FMResultSet? = taskDB.executeQuery(querySQL,
                                                               withArgumentsInArray: nil)
                
                while (results?.next() == true) {
                    
                    if (results?.stringForColumn("grp") == "Group") {
                        
                        taskMgr.taskGroups.append(taskGroup(name: (results?.stringForColumn("name"))!, desc: (results?.stringForColumn("desc"))!, group: (results?.stringForColumn("grp"))!))
                            
                    }
                        
                    else if (results?.stringForColumn("grp") == "Personal") {
                            
                        taskMgr.taskPersonals.append(taskPersonal(name: (results?.stringForColumn("name"))!, desc: (results?.stringForColumn("desc"))!, group: (results?.stringForColumn("grp"))!))
                    
                    }
                }
            
            taskDB.close()
            
        } else {
            print("Error: \(taskDB.lastErrorMessage())")
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returning
    override func viewWillAppear(animated: Bool) {
        
        tblTask.reloadData()
    
    }
    
    //Can Edit
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row >= 0) {
                return true
            }
        }
        
        return false
    }
    
    //Editing
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRow = self.tblTask.indexPathForSelectedRow
        let clicked: Int = 1
        let selected: Int = (selectedRow?.row)!
        
        if (selectedRow?.row >= 0) {
            
            if (customSwitch.on == true) {
                
                taskMgr.editTask(taskMgr.taskGroups[indexPath.row].name, newDesc: taskMgr.taskGroups[indexPath.row].desc, newGroup: taskMgr.taskGroups[indexPath.row].group, clicked: clicked, selected: selected)
            
                self.tabBarController?.selectedIndex = 1
        
            }
            
            if (customSwitch.on == false) {
                
                taskMgr.editTask(taskMgr.taskPersonals[indexPath.row].name, newDesc: taskMgr.taskPersonals[indexPath.row].desc, newGroup: taskMgr.taskPersonals[indexPath.row].group, clicked: clicked, selected: selected)
                
                self.tabBarController?.selectedIndex = 1
                
            }
        }
    }
    
    //Delete Task
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            if (customSwitch.on == true) {
                
                let taskGroupTitleText = taskMgr.testText(taskMgr.taskGroups[indexPath.row].name)
                let taskGroupDescText = taskMgr.testText(taskMgr.taskGroups[indexPath.row].desc)
            
                deleteFromDatabase(taskGroupTitleText, desc: taskGroupDescText, group: taskMgr.taskGroups[indexPath.row].group)
                taskMgr.taskGroups.removeAtIndex(indexPath.row)
                tblTask.reloadData()
        
            }
            
            if (customSwitch.on == false) {
                
                let taskPersonalTitleText = taskMgr.testText(taskMgr.taskPersonals[indexPath.row].name)
                let taskPersonalDescText = taskMgr.testText(taskMgr.taskPersonals[indexPath.row].desc)
                
                deleteFromDatabase(taskPersonalTitleText, desc: taskPersonalDescText, group: taskMgr.taskPersonals[indexPath.row].group)
                taskMgr.taskPersonals.removeAtIndex(indexPath.row)
                tblTask.reloadData()
                
            }
        }
    }

    //Calculate rows in TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var tableViewRow: Int = 0
        
        if (customSwitch.on == true) {
            
            tableViewRow = taskMgr.taskGroups.count
            
        }
        
        else if (customSwitch.on == false) {
            
            tableViewRow = taskMgr.taskPersonals.count
            
        }
        
        return tableViewRow
    }

    //Create new Cell in TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Code for using custom cell in xib file -> TableViewCell1.xib
        let cell = NSBundle.mainBundle().loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
        
        
        if (customSwitch.on == true) {
            
            if (taskMgr.taskGroups[indexPath.row].group == "Group") {
                
                cell.cellTitle.text = taskMgr.taskGroups[indexPath.row].name
                cell.cellDesc.text = taskMgr.taskGroups[indexPath.row].desc
                cell.cellGroup.text = taskMgr.taskGroups[indexPath.row].group
                
            }
            
        }
        
        else if (customSwitch.on == false) {
            
            if (taskMgr.taskPersonals[indexPath.row].group == "Personal") {
                
                cell.cellTitle.text = taskMgr.taskPersonals[indexPath.row].name
                cell.cellDesc.text = taskMgr.taskPersonals[indexPath.row].desc
                cell.cellGroup.text = taskMgr.taskPersonals[indexPath.row].group
                
            }
            
        }
        
        return cell
    }
    

    func deleteFromDatabase (name: String, desc: String, group: String) {
        
        let databaseName = "Tasks.db"
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0]
        
        let databasePath = docsDir.stringByAppendingPathComponent(databaseName)
        
        let taskDB = FMDatabase(path: databasePath as String)
        
        if taskDB.open() {
            
            let deleteSQL = "DELETE FROM SAVETASK WHERE name = '\(name)' AND desc = '\(desc)' AND grp = '\(group)'"
            
            let result = taskDB.executeUpdate(deleteSQL, withArgumentsInArray: nil)
            
            if !result {
                print("Error: \(taskDB.lastErrorMessage())")
            }
            
            taskDB.close()

        } else {
            print("Error: \(taskDB.lastErrorMessage())")
        }
    
    }

    @IBAction func switchAction(sender: AnyObject) {
        
        tblTask.reloadData()
        
    }
    
    
}

