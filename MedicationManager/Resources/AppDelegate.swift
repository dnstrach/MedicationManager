//
//  AppDelegate.swift
//  MedicationManager
//
//  Created by Dominique Strachan on 1/3/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { authorized, error in
            if let error = error {
                print("There was an error requesting permission to show local notifications: \(error)")
            }
            
            if authorized {
                UNUserNotificationCenter.current().delegate = self
                self.setNotificationsCategoties()
                print("✅ User granted authorized to show local notifications")
            } else {
                print("❌ User denied authorized to show local notifications")
            }
        }
        
        return true
    }
    
    private func setNotificationsCategoties() {
        let markTakenAction = UNNotificationAction(identifier: Strings.markTakenActionIdentifier, title: Strings.markTakenButtonTitle, options: UNNotificationActionOptions(rawValue: 0))
        
        let ignoreAction = UNNotificationAction(identifier: Strings.ignoreActionIdentifier, title: Strings.ignoreActonTitle, options: UNNotificationActionOptions(rawValue: 0))
        
        let category = UNNotificationCategory(identifier: Strings.notificationCategoryIdentifier, actions: [markTakenAction, ignoreAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //posting notification/sending signal with specific name
    //using notification not delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //different kind of userNotificationCenter
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.medicationReminderReceived), object: self)
        completionHandler([.sound, .badge, .banner])
    }
    
    //did receive for marking med as taken
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler complimentHandler: @escaping () -> Void) {
        if response.actionIdentifier == Strings.markTakenActionIdentifier,
           //setting id to taken
            let id = response.notification.request.content.userInfo[Strings.medicationIDKey] as? String {
            //calling medication controller to mark med as taken with id
            MedicationController.shared.markMedicationTaken(withID: id)
            complimentHandler()
        }
    }
}
