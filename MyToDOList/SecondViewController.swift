//
//  SecondViewController.swift
//  MyToDOList
//
//  Created by Matthew Ashley on 9/3/16.
//  Copyright © 2016 Matthew Ashley. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate, UITabBarDelegate {
    
    @IBOutlet var txtTask: UITextField!
    @IBOutlet var txtDesc: UITextField!
    @IBOutlet weak var secondViewControllerLabel: UILabel!
    @IBOutlet weak var buttonName: UIButton!
    
    var databasePath = NSString()
    
    //Will determine if a task has been selected in the TableView
    override func viewDidAppear(animated: Bool) {
        
        let clicked: Int = taskMgr.forceClicked()
        
        if (clicked == 0) {
            
            txtTask.text = ""
            txtDesc.text = ""
            
            secondViewControllerLabel.text = "Add Task"
            buttonName.setTitle("Add Task", forState: .Normal)
            
        }
        
        if (clicked == 1) {
            
            secondViewControllerLabel.text = "Edit Task"
            buttonName.setTitle("Update Task", forState: .Normal)
        
            let oldTask: String = taskMgr.forceTask()
            let oldDesc: String = taskMgr.forceDesc()
            
            txtTask.text = oldTask
            txtDesc.text = oldDesc
            
        }

    }
    
    override func viewDidDisappear(animated: Bool) {
        
        taskMgr.editTask("", newDesc: "", clicked: 0, selected: 0)
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Event for button click to either add a new task or update a task
    @IBAction func btnAddTask_Click (sender: UIButton) {
        
        if (secondViewControllerLabel.text == "Edit Task") {
            
            if ((txtTask.text == "" || txtDesc.text == "") || (txtTask.text == "" && txtDesc.text == "")) {
                
                self.tabBarController?.selectedIndex = 0
                
            }

            else {
                
                let oldName = taskMgr.forceTask()
                let oldDesc = taskMgr.forceDesc()
                
                let databaseName = "Tasks.db"
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir = dirPaths[0]
                
                let databasePath = docsDir.stringByAppendingPathComponent(databaseName)
                
                let taskDB = FMDatabase(path: databasePath as String)
                
                if taskDB.open() {
                    
                    let updateSQLname = "UPDATE TASKING SET name = '\(txtTask.text!)' WHERE name = '\(oldName)'"
                    let updateSQLdesc = "UPDATE TASKING SET desc = '\(txtDesc.text!)' WHERE desc = '\(oldDesc)'"
                    
                    if !taskDB.executeUpdate(updateSQLname, withArgumentsInArray: nil) {
                        
                        print("Error: \(taskDB.lastErrorMessage())")
                        
                    }
                    
                    if !taskDB.executeUpdate(updateSQLdesc, withArgumentsInArray: nil) {
                        
                        print("Error: \(taskDB.lastErrorMessage())")
                        
                    }
                    taskDB.close()
                }
                else {
                    print("Error: \(taskDB.lastErrorMessage())")
                }

                let updateRow2: Int = taskMgr.forceSelect()
                
                taskMgr.updateTask(txtTask.text!, desc: txtDesc.text!, updateRow: updateRow2)
                self.view.endEditing(true)
                txtTask.text = ""
                txtDesc.text = ""
                self.tabBarController?.selectedIndex = 0
                
            }
            
        }
        
        if (secondViewControllerLabel.text == "Add Task") {
            
            if ((txtTask.text == "" || txtDesc.text == "") || (txtTask.text == "" && txtDesc.text == "")) {
                
                self.tabBarController?.selectedIndex = 0
            
            }
            
            else {
                
                let databaseName = "Tasks.db"
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir = dirPaths[0] 
                
                let databasePath = docsDir.stringByAppendingPathComponent(databaseName)
                
                let taskDB = FMDatabase(path: databasePath as String)
                
                if taskDB.open() {
                    
                    let insertSQL = "INSERT INTO TASKING (name, desc) VALUES ('\(txtTask.text!)', '\(txtDesc.text!)')"
                    
                    let result = taskDB.executeUpdate(insertSQL,
                                                         withArgumentsInArray: nil)
                    
                    if !result {
                        print("Error: \(taskDB.lastErrorMessage())")
                    }
                    taskDB.close()
                } else {
                    print("Error: \(taskDB.lastErrorMessage())")
                } 
                
                taskMgr.addTask(txtTask.text!, desc: txtDesc.text!)
                self.view.endEditing(true)
                txtTask.text = ""
                txtDesc.text = ""
                self.tabBarController?.selectedIndex = 0

            }
            
        }
        
    }
    
    //Touch Function
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

    
}

