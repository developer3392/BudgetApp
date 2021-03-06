//
//  CPSC362 - Group Project Sprint 2
//  Chary Vielma, Vimean Chea, Charles Bucher, Jeffrey Guerra
//  This controller declares the table view variables.
//
//  summaryTableViewCell.swift
//  BudgetApp
//
//  Utilized tutorial to implement field functionalites.
//  Credit to Bart Jacobs at cocoacasts.com.
//

import UIKit

class summaryTableViewCell: UITableViewCell
{
    static let reuseIdentifier = "reuseTableCell"
    
    // Table view variables
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var txtAmount: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtCat: UILabel!
 
    override func awakeFromNib()
    {
        self.txtDescription.font = UIFont(name: "OpenSans-Regular", size: 12)
        self.txtAmount.font = UIFont(name: "OpenSans-Regular", size: 12)
        //self.txtDate.font = UIFont(name: "OpenSans-Regular", size: 12)
        self.txtCat.font = UIFont(name: "OpenSans-Regular", size: 12)
        super.awakeFromNib()
    }
}
