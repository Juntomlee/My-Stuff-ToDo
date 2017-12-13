//
//  ViewController.swift
//  ToDoList
//
//  Created by jun lee on 9/26/17.
//  Copyright © 2017 jun lee. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    var todo: ToDo? //Setting a variable "todo" for ToDo class
    
    // MARK: Outlets
    @IBOutlet weak var myTableView: UITableView!//setting Outlet for myTableView
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailedInfoTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleAddButtonOutlet: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    
    // MARK: Actions
    @IBAction func cancel(_ sender: Any) {
        //if cancel from AddMode, dismiss
        let isPresentingInAddToDoMode = presentingViewController is UINavigationController
        
        if isPresentingInAddToDoMode {
            dismiss(animated: true, completion: nil)
        }
        //if cancel from editing mode, pop the controller
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.backgroundColor = UIColor.white

        //Delegate for TextFields
        titleTextField.delegate = self
        detailedInfoTextField.delegate = self
        // Set up views if editing an existing Meal.
        if let todo = todo {
            if todo.listTitle != ""{
                navigationItem.title = "\(todo.listTitle)"
                titleTextField.text = todo.listTitle
            } else {
                navigationItem.title = "New List"
            }
        }
        if (titleTextField.text?.isEmpty)!{
            saveButton.isEnabled = false
        }
        
        isNew()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isNew()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: UITextFieldDelegate
    //Hide the keyboard when pressed return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        //Assigning each textfield seperately
        if textField == titleTextField{
            addListTitle()
        } else if textField == detailedInfoTextField {
            addListItem(textField.text!)
        }
    }
    
    //Disable Save button if textfield is empty
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if titleTextField.text != ""{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        return true
    }

    // Setting tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let myToDo = todo?.listItems
        if myToDo != nil {
            return (myToDo?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Change color for alternate cells
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor(red: 239/255, green: 154/255, blue: 154/255, alpha: 1)


        } else {
            cell.backgroundColor = UIColor(red: 255/255, green: 205/255, blue: 210/255, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailTableViewCell  else {
            fatalError()
        }
        // Round corners with shadows
        cell.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: cell.bounds)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = shadowPath2.cgPath
        
        //set todo constant to have value of todoArray
        let myTodo = todo

        if myTodo != nil {
            print(indexPath.row)
            cell.detailLabel.text = myTodo!.listItems[indexPath.row]
        }
        
        if myTodo?.isCompleted[indexPath.row] == false {
            cell.detailCheckButton.isSelected = false
        } else if myTodo?.isCompleted[indexPath.row] == true {
            cell.detailCheckButton.isSelected = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            if todo?.isCompleted[indexPath.row] == true {
                todo?.isCompleted[indexPath.row] = false
                navigationItem.leftBarButtonItem?.isEnabled = false
            } else {
                todo?.isCompleted[indexPath.row] = true
                navigationItem.leftBarButtonItem?.isEnabled = false
            }
        }
        tableView.reloadData()
    }
    
    func isNew(){
        if !(todo?.listTitle.isEmpty)! {
            titleTextField.isHidden = true
            titleAddButtonOutlet.isHidden = true
            detailedInfoTextField.isHidden = false
            addItemButton.isHidden = false
        } else {
            titleTextField.isHidden = false
            titleAddButtonOutlet.isHidden = false
            detailedInfoTextField.isHidden = true
            addItemButton.isHidden = true
        }
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender) //
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        let title = titleTextField.text ?? ""

        if todo?.listItems == nil {
            let detail = detailedInfoTextField.text ?? ""
            todo = ToDo(listTitle: title, listItems: [detail], isCompleted: [])
        } else {
            todo = ToDo(listTitle: title, listItems: (todo?.listItems)!, isCompleted: (todo?.isCompleted)!)
        }
    }
    
    @IBAction func addDetailButton(_ sender: Any) {
        addListItem(detailedInfoTextField.text!)
    }
    
    @IBAction func addTitleButton(_ sender: Any) {
        addListTitle()
    }
    
    func addListTitle() {
        if titleTextField.text == "" {
            print("empty textfield")
        } else {
            navigationItem.title = "\(titleTextField.text ?? "")"
            titleTextField.isHidden = true
            titleAddButtonOutlet.isHidden = true
            detailedInfoTextField.isHidden = false
            addItemButton.isHidden = false
        }
    }
    
    func addListItem(_ listItem: String) {
        if detailedInfoTextField.text == ""{
            print("empty textfield")
        } else {
            todo?.listItems.append(listItem)
            todo?.isCompleted.append(false)
        }
        myTableView.reloadData()
        detailedInfoTextField.text = ""
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //Delete row and update
            tableView.beginUpdates()
            todo?.listItems.remove(at: indexPath.row)
            todo?.isCompleted.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}

