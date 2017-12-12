//
//  ViewController.swift
//  ToDoList
//
//  Created by jun lee on 9/26/17.
//  Copyright © 2017 jun lee. All rights reserved.
//

import UIKit
import os.log
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    var todo: ToDo? //Setting a variable "todo" for ToDo class
    
    @IBOutlet weak var myTableView: UITableView!//setting Outlet for myTableView
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailedInfoTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func detailCheckButton(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected//Toggle button to switch checkmark button
    }
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
        //Delegate for TextFields
        titleTextField.delegate = self
        detailedInfoTextField.delegate = self
        // Set up views if editing an existing Meal.
        if let todo = todo {
            navigationItem.title = "\(todo.title) List"
            titleTextField.text = todo.title
        }
        if (titleTextField.text?.isEmpty)!{
            saveButton.isEnabled = false
        }
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
            navigationItem.title = "\(todo!.title) List"
            //titleTextField.isHidden = true
        }
        else if textField == detailedInfoTextField {
            detailedInfoTextField.text = textField.text
        }
    }
    
    //Disable Save button if textfield is empty
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      //  let text = (titleTextField.text! as NSString).replacingCharacters(in: range, with: string)
        
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
        let myToDo = todo?.detail
        if myToDo != nil {
            return (myToDo?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Change color for alternate cells
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        } else {
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "detailCell"
        print("passed cellidentifier")
        //Downcast to ToDoTableViewCell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DetailTableViewCell  else {
            fatalError()
        }
        
        print("IndexPath", indexPath.row)
        //set todo constant to have value of todoArray
        let myTodo = todo

        //print(myTodo!.detail[indexPath.row])
        if myTodo != nil {
            print(indexPath.row)
            cell.detailLabel.text = myTodo!.detail[indexPath.row]
            //print(myTodo!.detail[indexPath.row])
        }
        
        /*
        if myTodo?.check[indexPath.row] == "uncheck"{
            cell.accessoryType = .none
        } else if myTodo?.check[indexPath.row] == "check" {
            cell.accessoryType = .checkmark
        }
         */
        if myTodo?.check[indexPath.row] == "uncheck" {
            cell.detailCheckButton.isSelected = false
        } else if myTodo?.check[indexPath.row] == "check" {
            cell.detailCheckButton.isSelected = true
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            //if let myCell = tableView.cellForRow(at: indexPath) {
            //if myCell.accessoryType == .checkmark {
            //    myCell.accessoryType = .none
            //    todo?.check[indexPath.row] = "uncheck"
            //} else {
            //    myCell.accessoryType = .checkmark
            //    todo?.check[indexPath.row] = "check"
            //}
            if tableView.cellForRow(at: indexPath) != nil {
                if todo?.check[indexPath.row] == "check" {
                    todo?.check[indexPath.row] = "uncheck"
                    navigationItem.leftBarButtonItem?.isEnabled = false
                } else {
                    todo?.check[indexPath.row] = "check"
                    navigationItem.leftBarButtonItem?.isEnabled = false
                }
            }
        }
        tableView.reloadData()
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender) //
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        let title = titleTextField.text ?? ""

        if todo?.detail == nil {
            let detail = detailedInfoTextField.text ?? ""
            todo = ToDo(title: title, detail: [detail], check: [])
        } else {
            todo = ToDo(title: title, detail: (todo?.detail)!, check: (todo?.check)!)
        }
        //print("todo.detail", todo?.detail)
    }
    
    @IBAction func addDetailButton(_ sender: Any) {
        let myDetail = detailedInfoTextField.text
        //print("myDetail", myDetail)
        //print(todo?.detail)
        if detailedInfoTextField.text == ""{
            print("empty textfield")
        } else {
            todo?.detail.append(myDetail!)
            todo?.check.append("uncheck")
        }
        //print(todo?.detail)
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
            todo?.detail.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}

