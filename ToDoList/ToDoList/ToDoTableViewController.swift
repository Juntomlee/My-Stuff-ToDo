//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by jun lee on 9/26/17.
//  Copyright © 2017 jun lee. All rights reserved.
//

import UIKit
import UserNotifications

class ToDoTableViewController: UITableViewController {

    //MARK: Properties
    var todoArray = [ToDo]()
    public var remainderTimer: Double = 0.0
    func save() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: todoArray)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "todoArray")
    }
 
    //MARK: Private Methods
    //Setup sample list of ToDo List
    private func loadSampleTodos(){
        guard let todo1 = ToDo(title: "Practice Swift", detail: ["TableView", "Cell", "Delegate"], isCompleted: [false, true, true]) else {
            fatalError("Unable to instantiate 1")
        }
        guard let todo2 = ToDo(title: "Laundry", detail: ["Tshirts", "Pants", "Jacket"], isCompleted: [false, true, true]) else {
            fatalError("Unable to instantiate todo2")
        }
        guard let todo3 = ToDo(title: "Grocery Shopping", detail: ["Fruit", "Scallop", "Chips", "Beer"], isCompleted: [false, true, true, true]) else {
            fatalError("Unable to instantiate todo3")
        }
        todoArray += [todo1, todo2, todo3]
        save()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadSampleTodos() //Load sample ToDos when starting the app
        //load User Defaults
        let defaults = UserDefaults.standard
        
        if let savedToDo = defaults.object(forKey: "todoArray") as? Data {
            todoArray = NSKeyedUnarchiver.unarchiveObject(with: savedToDo) as! [ToDo]
            print(todoArray)
        }
        
        //Request Authorization for notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didallow, error in })
        
        //Longpress recognizer for notification
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        //for Motion feature(shake to sort)
        self.becomeFirstResponder()
    }

    // Sorting
    func sortList() {
        todoArray.sort(){$0.isCompleted.filter{$0 == false}.count > $1.isCompleted.filter{$0 == false}.count}
        // notify the table view the data has changed
        tableView.reloadData()
    }
    
    // Become FirstResponder when motion detected
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            sortList()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // One section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Total number of todos object
        return todoArray.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Change color for alternate cells
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        } else {
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        }
    }
    
    //Notification function for longpress gesture recognizer
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            //Get the tapped cell location
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if tableView.indexPathForRow(at: touchPoint) != nil {
                let selectedIndex = tableView.indexPathForRow(at: touchPoint)

                let todoContent = UNMutableNotificationContent()
                todoContent.title = todoArray[(selectedIndex?.row)!].title
                todoContent.subtitle = "You have " + "\(todoArray[(selectedIndex?.row)!].isCompleted.filter{$0 == false}.count)" + " items left to do."
                todoContent.badge = 1
                
                //Notify user for reminder
                let alertController = UIAlertController(title: "Reminder", message: "You will be reminded in 1hour", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)

                let todoTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
                let todoRequest = UNNotificationRequest(identifier: "timerdone", content: todoContent, trigger: todoTrigger)
                
                UNUserNotificationCenter.current().add(todoRequest, withCompletionHandler: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setting up custom cell called "myCell"
        let cellIdentifier = "myCell"
    
        //Downcast to ToDoTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ToDoTableViewCell  else {
            fatalError()
        }
        
        //set todo constant to have value of todos array at indexpath.row
        let todo = todoArray[indexPath.row]
        
        //assign value to titlelabel
        cell.titleLabel.text = todo.title
        let numberOfItemsLeft = todo.isCompleted.filter{$0 == false}.count
        if todo.isCompleted.isEmpty {
            cell.countLabel.text = "You do not have any item"
            cell.checkBoxButton.isSelected = false
        } else if numberOfItemsLeft == 0 {
            cell.countLabel.text = "You have nothing left to do!"
            cell.checkBoxButton.isSelected = true
        } else if numberOfItemsLeft == 1{
            cell.countLabel.text = "You have \(todo.isCompleted.filter{$0 == false}.count) item left"
            cell.checkBoxButton.isSelected = false
        } else if numberOfItemsLeft > 1{
            cell.countLabel.text = "You have \(todo.isCompleted.filter{$0 == false}.count) items left"
            cell.checkBoxButton.isSelected = false
        }
        return cell
    }
    
    //Delete using swipe
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            tableView.beginUpdates()
            todoArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
            save()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {
        case "AddItem":
            guard let todoDetailViewController = segue.destination as? ViewController else {
                fatalError()
            }
            let newArray = ToDo(title: "", detail: [], isCompleted: [])
            todoDetailViewController.todo = newArray
            
        case "ShowDetail":
            guard let todoDetailViewController = segue.destination as? ViewController else {
                fatalError()
            }
            guard let selectedTodoCell = sender as? ToDoTableViewCell else {
                fatalError()
            }
            guard let indexPath = tableView.indexPath(for: selectedTodoCell) else {
                fatalError()
            }
            
            let selectedToDo = todoArray[indexPath.row]
            todoDetailViewController.todo = selectedToDo

        default:
            fatalError()
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToToDoList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let retrieveTodo = sourceViewController.todo{
            print(retrieveTodo.title)
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing todo
                todoArray[selectedIndexPath.row] = retrieveTodo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: todoArray)
                UserDefaults.standard.set(encodedData, forKey: "todoArray")

            } else {
                // new todo
                let newIndexPath = IndexPath(row: todoArray.count, section: 0)
                todoArray.append(retrieveTodo)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: todoArray)
                UserDefaults.standard.set(encodedData, forKey: "todoArray")
            }
        }
    }
}
