//
//  CPSC362 Group Project
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
//

import UIKit
import CoreData

class transactionDetailViewController: UIViewController {

    //MARK: Properties    
    @IBOutlet var txtDescription: UITextField!
    @IBOutlet var txtAmount: UITextField!
    @IBOutlet var dateDate: UIDatePicker!
    
    var managedObjectContext: NSManagedObjectContext?
    var transaction: Transaction?
    
    //MARK: Initialization    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add additional setup after loading the view if needed
        if let transaction = transaction
        {
            txtDescription.text = transaction.txtDesc
            txtAmount.text = String(describing: transaction.amount!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        txtDescription.becomeFirstResponder()
    }
    
    // Cancel button is pressed: return to previous scene
    @IBAction func cancelAsSender(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    // Save button is pressed
    @IBAction func save(sender: UIBarButtonItem) {
        // Safeguard against empty text box fields
        guard let managedObjectContext = managedObjectContext else { return }
        guard let text = txtDescription.text, !text.isEmpty else { return }
        guard let text2 = txtAmount.text, !text2.isEmpty else { return }
        
        if transaction == nil{
        // Create Transaction
        let transaction = Transaction(context: managedObjectContext)
        
        // Configure Transaction
        transaction.txtDesc = txtDescription.text
        transaction.amount =  NSDecimalNumber(string: txtAmount.text)
        transaction.date = dateDate.date as NSDate
        }
        
        // Set transaction values
        if let transaction = transaction{
            transaction.txtDesc = txtDescription.text
            
            transaction.amount =  NSDecimalNumber(string: txtAmount.text)
            
            transaction.date = dateDate.date as NSDate
        }
        

        // Return to previous screen 
        self.dismiss(animated: true, completion: nil)
    }

}
