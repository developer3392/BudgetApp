//
//  settingsViewController.swift
//  BudgetApp
//
//  Created by Jeffrey Guerra on 6/22/17.
//  Copyright © 2017 Chary. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {
    
    @IBOutlet weak var currentBudget: UILabel!
    
   
    
    override func viewDidLoad() {
        let budgetAmt = UserDefaults.standard.double(forKey:"budgetAmount")
        currentBudget.text = String(String(format: "$%.2f", budgetAmt))
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    @IBOutlet weak var newBudget: UITextField!
    
    
    @IBAction func settingsSubmit(_ sender: Any) {
        UserDefaults.standard.set(Double(newBudget.text!), forKey:"budgetAmount")
    }
    
    
    
   
    
   // @IBAction func settingsSubmit
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
