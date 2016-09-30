
import UIKit

var taskMgr: TaskManager = TaskManager()

struct taskGroup {
    var name = "Un-Named"
    var desc = "Un-Described"
    var group = "Un-Selected"
}

struct taskPersonal {
    var name = "Un-Named"
    var desc = "Un-Described"
    var group = "Un-Selected"
}


class TaskManager: NSObject {
    
    var taskGroups = [taskGroup]()
    var taskPersonals = [taskPersonal]()
    var textArray = [String]()
    var taskTxt: String = ""
    var newTask2: String = ""
    var newDesc2: String = ""
    var newGroup2: String = ""
    var clicked2: Int = 0
    var selected2: Int = 0
    var y: Int = 0
    var z: Int = 0

    //Adds a new row of values to the taskGroup array
    func addTaskGroup (name: String, desc: String, group: String) {
        
        taskGroups.append(taskGroup(name: name, desc: desc, group: group))
        
    }
    
    //Adds a new row of values to the taskPersonal array
    func addTaskPersonal (name: String, desc: String, group: String) {
        
        taskPersonals.append(taskPersonal(name: name, desc: desc, group: group))
        
    }
    
    //Sets variables to be used in other ViewController files
    func editTask (newTask: String, newDesc: String, newGroup: String, clicked: Int, selected: Int) {
        
        newTask2 = newTask
        newDesc2 = newDesc
        newGroup2 = newGroup
        clicked2 = clicked
        selected2 = selected
        
    }
    
    //Updates a existing group task
    func updateTaskGroup (name: String, desc: String, group: String, updateRow: Int) {
        
        taskGroups.removeAtIndex(updateRow)
        taskGroups.insert(taskGroup(name: name, desc: desc, group: group), atIndex: updateRow)
        
    }
    
    //Updates a existing personal task
    func updateTaskPersonal (name: String, desc: String, group: String, updateRow: Int) {
        
        taskPersonals.removeAtIndex(updateRow)
        taskPersonals.insert(taskPersonal(name: name, desc: desc, group: group), atIndex: updateRow)
        
    }
    
    //Removes a existing group task and adds it to a personal task
    func updateRemoveGroup (name: String, desc: String, group: String, updateRow: Int) {
        
        taskGroups.removeAtIndex(updateRow)
        taskPersonals.append(taskPersonal(name: name, desc: desc, group: group))
    }
    
    //Removes a existing personal task and adds it to a group task
    func updateRemovePersonal (name: String, desc: String, group: String, updateRow: Int) {
        
        taskPersonals.removeAtIndex(updateRow)
        taskGroups.append(taskGroup(name: name, desc: desc, group: group))
        
    }
    
    //Sets the text for the txtTask: UITextField in the SecondViewController
    func forceTask () -> (String){
        
        return (newTask2)
    }
    
    //Sets the text for the txtDesc: UITextField in the SecondViewontroller
    func forceDesc () -> (String){
        
        return (newDesc2)
    }

    //Sets the value of the customPicker: UIPicker in the SecondViewController
    func forceGroup () -> (String) {
        
        return (newGroup2)
    }
    
    //Determines if a task has been selected or not in the TableView
    func forceClicked () -> (Int) {
        
        return (clicked2)
    }
    
    //Determines which task was selected in the TableView
    func forceSelect () -> (Int) {
        
        return (selected2)
    }
    
    /*Determines if the text of a inputed String variable has a single quote in it or not. If
     the text does, then the syntax of the text is corrected to be inserted into or deleted from
     the local database*/
    func testText(Text: String) -> (String) {
        
        textArray = [String]()
        taskTxt = ""
        y = 0
        
        for char in Text.characters {
            
            textArray.append(String(char))
            
            if (char == "'") {
                
                z = (y + 1)
                textArray.insert("'", atIndex: z)
                z = 0
                y = (y + 1)
                
            }
            
            y = (y + 1)
        }

        
        for a: Int in 0 ..< y {
            
            taskTxt = (taskTxt + textArray[a])
            
        }
        
        return (taskTxt)
    }
    
}
