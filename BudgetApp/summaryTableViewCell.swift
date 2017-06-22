//
//  CPSC362 Group Project
//  Chary Vielma, Vimean Chea, Charles Bucher, Jeffrey Guerra
//  This controller declares the table view variables
//
//  summaryTableViewCell.swift
//  BudgetApp
//
//  Utilized tutorial to implement field functionalites.
//  Credit to Bart Jacobs at cocoacasts.com.
//

import UIKit

class summaryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "reuseTableCell"
    
    // Table view variables
    @IBOutlet var txtDescription: UILabel!
    @IBOutlet var txtAmount: UILabel!
    @IBOutlet var txtDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
