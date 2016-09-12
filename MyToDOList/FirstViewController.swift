//
//  FirstViewController.swift
//  MyToDOList
//
//  Created by Matthew Ashley on 9/3/16.
//  Copyright © 2016 Matthew Ashley. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet var tblTask: UITableView!
    
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
                
                let sql_stmt = "CREATE TABLE IF NOT EXISTS TASKING (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT(100), DESC TEXT(100))"
                
                if !taskDB.executeStatements(sql_stmt) {
                    
                    print("Error: \(taskDB.lastErrorMessage())")
                    
                }
                
            }
            else {
                print("Error: \(taskDB.lastErrorMessage())")
            }
            
        }

        if taskDB.open() {
            
                let querySQL = "SELECT * FROM TASKING"
            
                let results:FMResultSet? = taskDB.executeQuery(querySQL,
                                                               withArgumentsInArray: nil)
                
                while (results?.next() == true) {
                    
                    taskMgr.tasks.append(task(name: (results?.stringForColumn("name"))!, desc: (results?.stringForColumn("desc"))!))
                    
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
            
            taskMgr.editTask(taskMgr.tasks[indexPath.row].name, newDesc: taskMgr.tasks[indexPath.row].desc, clicked: clicked, selected: selected)
            
            self.tabBarController?.selectedIndex = 1
            
        }
        
    }
    
    //Delete Task
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            deleteFromDatabase(taskMgr.tasks[indexPath.row].name, desc: taskMgr.tasks[indexPath.row].desc)
            taskMgr.tasks.removeAtIndex(indexPath.row)
            tblTask.reloadData()
        }
        
    }

    //Calculate rows in TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskMgr.tasks.count
    }

    //Create new Table in TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Default")
        
        cell.textLabel?.text = taskMgr.tasks[indexPath.row].name
        cell.detailTextLabel?.text = taskMgr.tasks[indexPath.row].desc
        
        return cell
    }
    

    func deleteFromDatabase (name: String, desc: String) {
        
        let databaseName = "Tasks.db"
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0]
        
        let databasePath = docsDir.stringByAppendingPathComponent(databaseName)
        
        let taskDB = FMDatabase(path: databasePath as String)
        
        if taskDB.open() {
            
            let deleteSQL = "DELETE FROM TASKING WHERE name = '\(name)' AND desc = '\(desc)'"
            
            let result = taskDB.executeUpdate(deleteSQL, withArgumentsInArray: nil)
            
            if !result {
                print("Error: \(taskDB.lastErrorMessage())")
            }
            taskDB.close()
        } else {
            print("Error: \(taskDB.lastErrorMessage())")
        }
    
    }

}

