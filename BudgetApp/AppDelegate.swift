//  
//  CPSC362 - Group Project Sprint 2
//  Chary Vielma, Vimean Chea, Charles Bucher, Jeffrey Guerra
//  This program enables users to keep track of a current balance based on a budget amount
//  and individual transactions entered by the user. At first-time launch the user is 
//  asked for their budget amount, period type, and start date. The user is taken to a 
//  summary page which displays their current balance and a list of the current period's 
//  transactions. They have the ability to navigate to a transaction detail scene which 
//  allows them to enter a description, amount, category type, and date. They are also able
//  to navigate to a settings scene where they may update their budget amount for the 
//  current period.
//
//  Utitlized mulitple YouTube tutorials to learn about creating a first-time launch view
//  [YouTube Channel] - "Title of Video"
//  bryce kroecke - "Detecting first time app launch in swift 3.0"
//  The Swift Guy - "How To Store Data Permanently With User Defaults In xCode 8 (Swift 3.0)"

import UIKit
import CoreData

//MARK: Global Values
// Is set when UserDefaults is tested for launchedBefore status
var firstLaunch: Bool = false
// Used to ensure user successfully entering initial information without closing the ap
var finishedSettingUp: Bool = false

// Period type values
let periodTypeList = ["Weekly", "Biweekly", "Monthly"]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        //How to set navigation background color in AppDelegate
        UINavigationBar.appearance().barTintColor = UIColor(red: 109.0/255.0, green: 158.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        
        //How to set navigation bar color in AppDelegate
        UINavigationBar.appearance().tintColor = UIColor.white
        
        //How to set navigation bar title text color in AppDelegate
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //How to set status bar light Content in AppDelegate
        //set the View Controller-based status bar appearance
        
        UIApplication.shared.statusBarStyle = .lightContent

        // Edit firstLaunch/launcedBefore variables
        // Since the initializer for UserDefaults.bool values is false, then if launchedBefore is false, then
        // this must be the first time the app was launched, so set firstLaunch to true
        firstLaunch = !UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if firstLaunch
        {
            UserDefaults.standard.set(firstLaunch, forKey: "launchedBefore")
        }
        else
        {
            // Since they have launched before, then the user must have finished setting up
            finishedSettingUp = true
            
            // Ensure that period start date is accurate....
            let dateHelper = DateHandler()
            dateHelper.ensureCurrentPeriod()
        }
        
        // Ensure all data is written to disk before moving on.
        _ = UserDefaults.standard.synchronize()
        
        // Determine which view controller class and storyboard ID to send the user to
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if(firstLaunch)
        {
            // First time launch takes user to the first launch controller
            let initialViewController: firstLaunchViewController = mainStoryboard.instantiateViewController(withIdentifier: "firstLaunchSBID") as! firstLaunchViewController
            self.window?.rootViewController = initialViewController
        }
        else
        {
            // Go to main home page
            let initialViewController: periodSummaryViewController = mainStoryboard.instantiateViewController(withIdentifier: "homepageSBID") as! periodSummaryViewController
            self.window?.rootViewController = initialViewController
        }
        
        self.window?.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        if !finishedSettingUp
        {
            // User did not successfully finish setting up. Update this value so
            // next app launch is the "first" time
            UserDefaults.standard.set(false, forKey: "launchedBefore")
        }
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "dataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CoreDataSwift", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CoreDataSwift.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var managedObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *){
            
            managedObjectContext = self.persistentContainer.viewContext
        }
        else{
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
            
        }
        return managedObjectContext!
    }()
}
