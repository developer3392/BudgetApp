//
//  firstLaunchViewController.swift
//  BudgetApp
//
//  Created by Charles Bucher on 6/17/17.
//  Copyright © 2017 Chary. All rights reserved.
//  Utitlized mulitple YouTube tutorials to learn about picker view

//  [YouTube Channel] - "Title of Video"
//  Quick Reference - "UIPickerView as input for UITextField in Swift"
//  Jared Davidson - "Using Picker Views (Swift : Xcode)"
//  Yp.py - "UI Date Picker for UI Text Field(with UI Tool Bar) (Swift 3 + Xcode8)"
//  The Swift Guy - "How To Use A Picker View In Xcode 8 (Swift 3.0)"
//  bryce kroecke - "Detecting first time app launch in swift 3.0"
//  The Swift Guy - "How To Store Data Permanently With User Defaults In xCode 8 (Swift 3.0)"

import UIKit

class firstLaunchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var budgetAmount: UITextField!
    @IBOutlet weak var periodType: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var dataValidationMessage: UILabel!
    
    let startDatePicker = UIDatePicker()
    let periodTypePicker = UIPickerView()
    private var startDate_DateType: Date?
    
    //MARK: Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createStartDatePicker()
        createPeriodTypePicker()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return periodTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        periodType.text = periodTypeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return periodTypeList[row]
    }
    
    //MARK: Actions
    @IBAction func pressedGetStarted(_ sender: UIButton)
    {
        if validateData()
        {
            finishedSettingUp = true // User entered all information, so we will never come back to this view controller
            dataValidationMessage.text = ""
            
            // Set user default values!
            
            UserDefaults.standard.set(periodType.text, forKey: "periodType")
            UserDefaults.standard.set(startDate_DateType, forKey: "startDate")
        }
        else
        {
            dataValidationMessage.text = "One or more fields were not entered correctly. Please try again."
        }
    }
    
    //MARK: Navigation
    // Ensure user finished entering all values. Since this function runs before pressedGetStarted,
    // error checking happens in here instead of there
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        return validateData()
    }
    
    //MARK: Pop-up Pickers
    // Start Date
    func createStartDatePicker()
    {
        // Format date picker
        startDatePicker.datePickerMode = .date
        
        // Create toolbar that date picker will appear in
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done item on toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDateDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        startDate.inputAccessoryView = toolbar
        
        // Assigning date picker to text field
        startDate.inputView = startDatePicker
    }
    
    func startDateDonePressed()
    {
        // Format date picker
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // Set text box value
        startDate.text = dateFormatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
        
        // Save to local variable
        startDate_DateType = startDatePicker.date
    }
    
    // Period Type
    func createPeriodTypePicker()
    {
        // Create toolbar that date picker will appear in
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done item on toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(periodTypeDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        periodType.inputAccessoryView = toolbar
        
        // Assign the data/datePicker functions to our periodTypePicker
        periodTypePicker.delegate = self
        periodTypePicker.dataSource = self
        
        // Assigning period type picker to text field
        periodType.inputView = periodTypePicker
    }
    
    func periodTypeDonePressed()
    {
        self.view.endEditing(true)
    }
    
    //MARK: Other functions
    func validateData() -> Bool
    {
        var validData: Int = 0
        
        // User input validation first
        if let budgetAmountOkay = Double(budgetAmount.text!)
        {
            // Amount was entered and is not negative
            if budgetAmountOkay >= 0
            {
                validData += 1
            }
        }
        // Period type is not empty/nil
        if periodType.text != nil && periodType.text! != ""
        {
            validData += 1
        }
        // Start data is not empty/nil
        if startDate.text != nil && startDate.text! != ""
        {
            validData += 1
        }
        
        // Check if all data was entered
        if validData == 3
        {
            return true
        }
        else
        {
            return false
        }
    }
}
