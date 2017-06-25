//
//  CPSC362 - Group Project Sprint 2
//  Chary Vielma, Vimean Chea, Charles Bucher, Jeffrey Guerra
//  This controller handles the Settings scene.
//  User may change their budget amount by entering a new amount.
//  New amount will be updated in the UserDefaults budget
//  variable.
//
//  settingsViewController.swift
//  BudgetApp
//

import UIKit

class settingsViewController: UIViewController
{
    
    @IBOutlet weak var currentBudget: UILabel!
    @IBOutlet weak var newBudget: UITextField!
    @IBOutlet weak var dataValidationMessage: UILabel!

    override func viewDidLoad()
    {
        //set the background color
        self.view.backgroundColor = UIColor(red: 215.0/255.0, green: 229.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        //set the font style
        self.currentBudget.font = UIFont(name: "OpenSans-Light", size: 12)
        self.newBudget.font = UIFont(name: "OpenSans-Light",size: 12)
        self.dataValidationMessage.font = UIFont(name: "OpenSans-Light", size: 12)
        
        let budgetAmt = UserDefaults.standard.double(forKey:"budgetAmount")
        currentBudget.text = String(String(format: "$%.2f", budgetAmt))
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    // Code when settings button is pressed under "shouldPerformSegue", as what needs
    // to happen is time sensitive, and shouldPerformSegue is called first
    @IBAction func settingsSubmit(_ sender: Any)
    {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    }
    
    // Will perform data validation, as well as saving newly entered amount to User Defaults class
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        let safeAmount: Double = Double(newBudget.text!) ?? 0.00
    
        if safeAmount <= 0
        {
            dataValidationMessage.text = "One or more fields were not entered correctly. Please try again."
            return false // User is not ready to seque, as they didn't enter a valid budget amount
        }
        else
        {
            // Update user defaults
            UserDefaults.standard.set(Double(newBudget.text!), forKey:"budgetAmount")
            
            // Save to disk
            UserDefaults.standard.synchronize()
            
            dataValidationMessage.text = ""
            return true // User is ready to segue as they entered a valid amount
        }
    }
}
