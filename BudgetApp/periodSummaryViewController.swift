//
//  CPSC362 Group Project
//  Chary Vielma, Vimean Chea, Charles Bucher, Jeffrey Guerra
//  This view controller displays the user budget balance, 
//  table view of their transactions including description, 
//  date, and amount. Allows them the option to add, edit, 
//  delete transactions. They may also select a button to 
//  enter a settings tab.
//  periodSummaryViewController.swift
//  BudgetApp
//  Utilized tutorial to implement field functionalites.
//  Credit to Bart Jacobs at cocoacasts.com.
//

import UIKit
import CoreData

class periodSummaryViewController: UIViewController {
    private let segueAddTransactionDetailViewController = "SegueAddTransactionDetailViewController"
    private let segueEditTransactionDetailViewController = "SegueEditTransactionDetailViewController"

    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private let persistentContainer = NSPersistentContainer(name: "dataModel")


    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self.setupView()
                
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
            
            self.updateView()
            }
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == segueAddTransactionDetailViewController {
            if let destinationViewController = segue.destination as? transactionDetailViewController {
                
                destinationViewController.managedObjectContext = persistentContainer.viewContext
            }
        }
        guard let destinationViewController = segue.destination as? transactionDetailViewController else {return}
        destinationViewController.managedObjectContext = persistentContainer.viewContext
        
        if let indexPath = tableView.indexPathForSelectedRow,segue.identifier == segueEditTransactionDetailViewController{
            
            destinationViewController.transaction = fetchedResultsController.object(at: indexPath)
        }

    }
    
    private func setupView() {
        updateView()
    }

    fileprivate func updateView() {
        var hasTransactions = false
        
        if let transactions = fetchedResultsController.fetchedObjects {
            hasTransactions = transactions.count > 0
        }
        
        tableView.isHidden = !hasTransactions
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
}

extension periodSummaryViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
            
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;

        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
}

extension periodSummaryViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let transactions = fetchedResultsController.fetchedObjects else {return 0}
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: summaryTableViewCell.reuseIdentifier, for: indexPath) as? summaryTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Transaction
        let transaction = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.txtDescription.text = transaction.txtDesc
        cell.txtAmount.text = String(String(format: "$%.2f", transaction.amount!.doubleValue))
        
        // Format date picker
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // Set date cell value
        cell.txtDate.text = dateFormatter.string(for: transaction.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Transaction
            let transaction = fetchedResultsController.object(at: indexPath)
            
            // Delete Transaction
            transaction.managedObjectContext?.delete(transaction)
        }
    }
    
}
extension periodSummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}



