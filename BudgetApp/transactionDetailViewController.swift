//
//  CPSC362 - Group Project Sprint 2
//  Chary Vielma, Vimean Chea, Charles Bucher, Jeffrey Guerra
//  This controller handles the Transaction Detail scene.
//  It obtains the description, amount, and date from user
//  and saves it to the database via Core data.
//
//  transactionDetailViewController.swift
//  BudgetApp
//
//  Utilized tutorial to implement field functionalites.
//  Credit to Bart Jacobs at cocoacasts.com.
//  The Swift Guy - "How To Use A Picker View In Xcode 8 (Swift 3.0)"
//

import UIKit
import CoreData

class transactionDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: Properties    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var dDate: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    private var startDate_DateType: Date?
    var managedObjectContext: NSManagedObjectContext?
    var transaction: Transaction?
    var transDate: Date? = nil // Stores the transaction date to set the default value of the date picker
    
    
    // Configure Category picker 
    
    let categories = ["Groceries", "Dining", "Gas", "Education", "Housing", "Bills", "Automotive", "Entertainment", "Other"]
    
    //MARK: Initialization    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //change font style
        self.txtDescription.font = UIFont(name: "OpenSans-Light", size: 12)
        self.txtAmount.font = UIFont(name: "OpenSans-Light", size: 12)
        self.txtCategory.font = UIFont(name: "OpenSans-Light", size: 12)
        self.dDate.font = UIFont(name: "OpenSans-Light", size: 12)
        
                
        // Add additional setup after loading the view if needed
        if let transaction = transaction
        {
            txtDescription.text = transaction.txtDesc
            txtAmount.text = String(describing: transaction.amount!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
    
            // Set text box value
            transDate = transaction.date! as Date
            dDate.text = dateFormatter.string(for: transaction.date)
            txtCategory.text = transaction.category

            self.view.endEditing(true)
            
            
            //set the background color
            self.view.backgroundColor = UIColor(red: 215.0/255.0, green: 229.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        }
        
        createCategoryPicker()  // Initialize category picker
        createDatePicker() // Initialize date picker
    }
    
    // Set focus to Description
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        txtDescription.becomeFirstResponder()
    }
    
    // Create functions needed for category picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // Obtain number of rows in each component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return categories.count
    }
    
    // Set text field to the string at array location selected by the user
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == categoryPicker{
        self.txtCategory.text = self.categories[row]
            categoryPicker.isHidden = true
      /*  }
        else if pickerView == datePicker{
            self.dDate.text = self.*/
        }
 
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
       if(textField == self.txtCategory)
       {
            self.categoryPicker.isHidden = false
       }
        else if (textField == self.dDate)
       {
            self.datePicker.isHidden = false
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return categories[row]
    }
    
    
    // Date
    func createDatePicker()
    {
        // Format date picker
        datePicker.datePickerMode = .date
        
        // Initialize date if there is currently a value
        if transaction != nil
        {
            datePicker.date = transDate!
        }
        
        // Create date picker toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done item on toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        dDate.inputAccessoryView = toolbar
        
        // Assigning date picker to text field
        dDate.inputView = datePicker
    }
    
    func dateDonePressed()
    {
        // Format date picker
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // Set text box value
        dDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // Category
    func createCategoryPicker()
    {
        // Create category toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done item on toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(categoryDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        txtCategory.inputAccessoryView = toolbar
        
        // Assign the data/datePicker functions to our periodTypePicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        // Assigning period type picker to text field
        txtCategory.inputView = categoryPicker
    }
    
    // Hide dropdown menu
    func categoryDonePressed()
    {
        self.view.endEditing(true)
    }
    
    // Cancel button is pressed: return to previous scene
    @IBAction func cancelAsSender(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    // Save button is pressed
    @IBAction func save(sender: UIBarButtonItem)
    {
        // Safeguard against empty text box fields
        guard let managedObjectContext = managedObjectContext else { return }
        guard let text = txtDescription.text, !text.isEmpty else { return }
        guard let text2 = txtAmount.text, !text2.isEmpty else { return }
        guard let cat = txtCategory.text, !cat.isEmpty else { return }
        guard let date = dDate.text, !date.isEmpty else { return }
        // Check value is a decimal
        if let transAmount = Double(txtAmount.text!)
        {
            // Check for negative value
            if transAmount < 0
            {
                return
            }
        }
        else
        {
            return
        }
        
        if transaction == nil
        {
            // Create Transaction
            let transaction = Transaction(context: managedObjectContext)
            
            // Configure Transaction
            transaction.txtDesc = txtDescription.text
            transaction.amount = NSDecimalNumber(string: txtAmount.text)
            transaction.date = datePicker.date as NSDate
            transaction.category = txtCategory.text
        }
        
        // Set transaction values
        if let transaction = transaction
        {
            transaction.txtDesc = txtDescription.text
            transaction.amount = NSDecimalNumber(string: txtAmount.text)
            transaction.date = datePicker.date as NSDate
            transaction.category = txtCategory.text
        }
        
        // Return to previous screen 
        self.dismiss(animated: true, completion: nil)
    }
}
