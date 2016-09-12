
import UIKit

var taskMgr: TaskManager = TaskManager()

struct task {
    var name = "Un-Named"
    var desc = "Un-Described"
}

class TaskManager: NSObject {
    
    var tasks = [task]()
    var newTask2: String = ""
    var newDesc2: String = ""
    var clicked2: Int = 0
    var selected2: Int = 0
    
    //Adds a new task to the TableView
    func addTask (name: String, desc: String) {
        
        tasks.append(task(name: name, desc: desc))
        
    }
    
    //Sets variables to be used in other ViewController files
    func editTask (newTask: String, newDesc: String, clicked: Int, selected: Int) {
        
        newTask2 = newTask
        newDesc2 = newDesc
        clicked2 = clicked
        selected2 = selected
        
    }
    
    //Updates a existing task
    func updateTask (name: String, desc: String, updateRow: Int) {
        
        tasks.removeAtIndex(updateRow)
        tasks.insert(task(name: name, desc: desc), atIndex: updateRow)
        
    }
    
    //Sets the text for the txtTask: UITextField in the SecondViewController
    func forceTask () -> (String){
        
        return (newTask2)
    }
    
    //Sets the text for the txtDesc: UITextField in the SecondViewCOntroller
    func forceDesc () -> (String){
        
        return (newDesc2)
    }

    //Determines if a task has been selected or not in the TableView
    func forceClicked () -> (Int) {
        
        return (clicked2)
    }
    
    //Determines which task was selected in the TableView
    func forceSelect () -> (Int) {
        
        return (selected2)
    }
}
