//  
//  CPSC362 
//  Chary Vielma, Vimean Chea, Charles Bucher, Jeffrey Guerra

//  Utitlized mulitple YouTube tutorials to learn about creating a first-time launch view

//  [YouTube Channel] - "Title of Video"
//  bryce kroecke - "Detecting first time app launch in swift 3.0"
//  The Swift Guy - "How To Store Data Permanently With User Defaults In xCode 8 (Swift 3.0)"

import UIKit

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
            finishedSettingUp = true
        }
        
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
    
    
}
