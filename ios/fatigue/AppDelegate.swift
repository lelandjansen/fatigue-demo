import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Demo features
        UserDefaults.standard.firstLaunch = true
        UserDefaults.standard.rangeQuestionTutorialShown = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        window?.rootViewController = HomePageController(collectionViewLayout: layout)
        return true
    }
    
    enum Containers: String {
        case fatigue
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Containers.fatigue.rawValue)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
