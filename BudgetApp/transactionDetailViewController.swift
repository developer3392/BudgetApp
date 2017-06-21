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


extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

class transactionDetailViewController: UIViewController {

    @IBOutlet var txtDescription: UITextField!
    @IBOutlet var txtAmount: UITextField!
    @IBOutlet var dateDate: UIDatePicker!
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add additional setup after loading the view if needed
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        txtDescription.becomeFirstResponder()
    }
    
    @IBAction func cancelAsSender(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let text = txtDescription.text, !text.isEmpty else { return }
        guard let text2 = txtAmount.text, !text2.isEmpty else { return }

        // Create Transaction
        let transaction = Transaction(context: managedObjectContext)
        
        // Configure Transaction
        transaction.txtDesc = txtDescription.text
        transaction.amount =  NSDecimalNumber(string: txtAmount.text)
        transaction.date = dateDate.date as NSDate
        
        self.dismiss(animated: true, completion: nil)
    }

}
