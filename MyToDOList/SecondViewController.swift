//
//  SecondViewController.swift
//  MyToDOList
//
//  Created by Matthew Ashley on 9/3/16.
//  Copyright © 2016 Matthew Ashley. All rights reserved.
//

import UIKit
import CloudKit

class SecondViewController: UIViewController, UITextFieldDelegate, UITabBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var txtTask: UITextField!
    @IBOutlet var txtDesc: UITextField!
    @IBOutlet weak var secondViewControllerLabel: UILabel!
    @IBOutlet weak var customPicker: UIPickerView!
    @IBOutlet weak var buttonName: UIButton!
    
    var databasePath = NSString()
    var pickerArray = ["", "Personal", "Group"]
    var pickerSelected: Int = 0
    var pickerValue: String = ""
     
    //Will determine if a task has been selected in the TableView
    override func viewDidAppear(animated: Bool) {
        
        let clicked: Int = taskMgr.forceClicked()
        
        if (clicked == 0) {
            
            txtTask.text = ""
            txtDesc.text = ""
            
            secondViewControllerLabel.text = "Add Task"
            buttonName.setTitle("Add Task", forState: .Normal)
            customPicker.selectRow(0, inComponent: 0, animated: false)
            pickerValue = ""
            
        }
        
        if (clicked == 1) {
            
            secondViewControllerLabel.text = "Edit Task"
            buttonName.setTitle("Update Task", forState: .Normal)
        
            let oldName: String = taskMgr.forceTask()
            let oldDesc: String = taskMgr.forceDesc()
            let oldGroup: String = taskMgr.forceGroup()
            
            txtTask.text = oldName
            txtDesc.text = oldDesc
            
            if (oldGroup == "Personal") {
                customPicker.selectRow(1, inComponent: 0, animated: false)
                pickerValue = "Personal"
            }
            
            else if (oldGroup == "Group") {
                customPicker.selectRow(2, inComponent: 0, animated: false)
                pickerValue = "Group"
            }
        
        }

    }
    
    override func viewDidDisappear(animated: Bool) {
        
        taskMgr.editTask("", newDesc: "", newGroup: "", clicked: 0, selected: 0)
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        customPicker.delegate = self
        customPicker.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Event for button click to either add a new task or update a task
    @IBAction func btnAddTask_Click (sender: UIButton) {
        
        if (secondViewControllerLabel.text == "Edit Task") {
            
            if ((txtTask.text == "" || txtDesc.text == "" || pickerValue == "") || (txtTask.text == "" && txtDesc.text == "" && pickerValue == "")) {
                
                self.tabBarController?.selectedIndex = 0
                
            }

            else {
                
                let oldName: String = taskMgr.testText(taskMgr.forceTask())
                let oldDesc: String = taskMgr.testText(taskMgr.forceDesc())
                let oldGroup: String = taskMgr.forceGroup()
                let taskTitleTxt: String = taskMgr.testText(txtTask.text!)
                let taskDescTxt: String = taskMgr.testText(txtDesc.text!)
                
                let databaseName = "Tasks.db"
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir = dirPaths[0]
                
                let databasePath = docsDir.stringByAppendingPathComponent(databaseName)
                
                let taskDB = FMDatabase(path: databasePath as String)
                
                if taskDB.open() {
                    
                    let updateSQLname = "UPDATE SAVETASK SET name = '\(taskTitleTxt)' WHERE name = '\(oldName)' AND desc = '\(oldDesc)' AND grp = '\(oldGroup)'"
                    let updateSQLdesc = "UPDATE SAVETASK SET desc = '\(taskDescTxt)' WHERE name = '\(oldName)' AND desc = '\(oldDesc)' AND grp = '\(oldGroup)'"
                    let updateSQLgroup = "UPDATE SAVETASK SET grp = '\(pickerValue)' WHERE name = '\(oldName)' AND desc = '\(oldDesc)' AND grp = '\(oldGroup)'"
                    
                    if !taskDB.executeUpdate(updateSQLname, withArgumentsInArray: nil) {
                        
                        print("Error: \(taskDB.lastErrorMessage())")
                        
                    }
                    
                    if !taskDB.executeUpdate(updateSQLdesc, withArgumentsInArray: nil) {
                        
                        print("Error: \(taskDB.lastErrorMessage())")
                        
                    }
                    
                    if !taskDB.executeUpdate(updateSQLgroup, withArgumentsInArray: nil) {
                        
                        print("Error: \(taskDB.lastErrorMessage())")
                    }
                    
                    taskDB.close()
                    
                }else {
                    print("Error: \(taskDB.lastErrorMessage())")
                }

                let updateRow2: Int = taskMgr.forceSelect()
                let oldGroup2: String = taskMgr.forceGroup()
                
                if ((oldGroup2 == "Group") && (pickerValue == "Group")) {
                    
                    taskMgr.updateTaskGroup(txtTask.text!, desc: txtDesc.text!, group: pickerValue, updateRow: updateRow2)
                    self.view.endEditing(true)
                    self.tabBarController?.selectedIndex = 0
              
                }
                
                if ((oldGroup2 == "Personal") && (pickerValue == "Personal")) {
                    
                    taskMgr.updateTaskPersonal(txtTask.text!, desc: txtDesc.text!, group: pickerValue, updateRow: updateRow2)
                    self.view.endEditing(true)
                    self.tabBarController?.selectedIndex = 0
                    
                }
                
                if ((oldGroup2 == "Group") && (pickerValue == "Personal")) {
                    
                    taskMgr.updateRemoveGroup(txtTask.text!, desc: txtDesc.text!, group: pickerValue, updateRow: updateRow2)
                    self.view.endEditing(true)
                    self.tabBarController?.selectedIndex = 0

                    
                }
                
                if ((oldGroup2 == "Personal") && (pickerValue == "Group")) {
                    
                    taskMgr.updateRemovePersonal(txtTask.text!, desc: txtDesc.text!, group: pickerValue, updateRow: updateRow2)
                    self.view.endEditing(true)
                    self.tabBarController?.selectedIndex = 0

                }
            }
            
        }
        
        if (secondViewControllerLabel.text == "Add Task") {
            
            if ((txtTask.text == "" || txtDesc.text == "" || pickerValue == "") || (txtTask.text == "" && txtDesc.text == "" && pickerValue == "")) {
                
                self.tabBarController?.selectedIndex = 0
            
            }
            
            else {
                
                let taskTitleTxt: String = taskMgr.testText(txtTask.text!)
                let taskDescTxt: String = taskMgr.testText(txtDesc.text!)

                let databaseName = "Tasks.db"
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir = dirPaths[0] 
                
                let databasePath = docsDir.stringByAppendingPathComponent(databaseName)
                
                let taskDB = FMDatabase(path: databasePath as String)
                
                if taskDB.open() {
                    
                    let insertSQL = "INSERT INTO SAVETASK (name, desc, grp) VALUES ('\(taskTitleTxt)', '\(taskDescTxt)', '\(pickerValue)')"
                    
                    let result = taskDB.executeUpdate(insertSQL,
                                                         withArgumentsInArray: nil)
                    
                    if !result {
                        print("Error: \(taskDB.lastErrorMessage())")
                    }
                    
                    taskDB.close()
                    
                } else {
                    print("Error: \(taskDB.lastErrorMessage())")
                } 
                
                if (pickerSelected == 1) {
                    
                    taskMgr.addTaskPersonal(txtTask.text!, desc: txtDesc.text!, group: pickerValue)
                    self.view.endEditing(true)
                    self.tabBarController?.selectedIndex = 0
                    
                }
                
                if (pickerSelected == 2) {
                    
                    taskMgr.addTaskGroup(txtTask.text!, desc: txtDesc.text!, group: pickerValue)
                    self.view.endEditing(true)
                    self.tabBarController?.selectedIndex = 0
                    
                }
                
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

    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerArray[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerArray.count
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerSelected = row
    
        if (pickerSelected == 1) {
            pickerValue = "Personal"
        }
            
        else if (pickerSelected == 2) {
            pickerValue = "Group"
        }
        
        else {
            pickerValue = ""
        }
        
    }
    
    
}

