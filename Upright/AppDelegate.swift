//
//  AppDelegate.swift
//  Upright
//
//  Created by USS - Software Dev on 2/23/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
    
    func addObjForIdleTime(){
        NotificationCenter.default.addObserver(
                                            self,
                                            selector: #selector(showAlert_idle),
                                            name: NSNotification.Name(rawValue: "showAlert_idle"),
                                            object: nil
                                            )
    }

    @objc func showAlert_idle(){
        
       print("Auto log out")//do you logout here

    }
    
}

class CustomApplication: UIApplication {
private var timerToDetectInactivity: Timer?
private var timeIdleSecond: TimeInterval {
    return 1 * 60  // 5 min.
}

override func sendEvent(_ event: UIEvent) {
    //print("sendEvent... ")

    super.sendEvent(event)
    if let touches = event.allTouches {
        for touch in touches where touch.phase == UITouch.Phase.began {
            self.resetTimer()
        }
    }
}

// reset the timer because there was user event
private func resetTimer() {
    //print("resetTimer... ")

    if let timerToDetectInactivity = timerToDetectInactivity {
        timerToDetectInactivity.invalidate()
    }
    
    timerToDetectInactivity = Timer.scheduledTimer(timeInterval: timeIdleSecond,
                                         target: self,
                                         selector: #selector(CustomApplication.showAlert),
                                         userInfo: nil,
                                         repeats: false
        )
    }

    @objc private func showAlert() {
        //print("showAlert and logout... ")
        NotificationCenter.default.post(name: Notification.Name("showAlert_idle"), object: nil, userInfo: nil)
    }
    
}
