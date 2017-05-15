//
//  AppDelegate.swift
//  Together
//
//  Created by Андрей Цай on 04.08.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyUserDefaults

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var reachability: Reachability!
    var coreDataController: DataController!
    var locationManager: CLLocationManager!
    var locationDataProvider: RxLocationManagerSharedDelegate!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(NetworkConfig.GoogleMapsAPIkey)
        GMSPlacesClient.provideAPIKey(NetworkConfig.GoogleMapsAPIkey)
        locationManager = CLLocationManager()
        locationDataProvider = RxLocationManagerSharedDelegate()
        self.reachability = Reachability.forInternetConnection()
        self.reachability.startNotifier()
        if !Defaults.hasKey(.defaultsValid) {
            DefaultsTools.initValues()
        }
        self.coreDataController = DataController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.coreDataController.saveData()
    }

}

// REVIEW: Project structure
// Create a 'Resources' folder and put there everything none-"code" there e.g. Fonts, Assets.
// Use the following structure:
/*
 
 When grouping files, group them by FUNCTIONALITY, not their TYPE.
 So instead of creating Storyboards folder and putting all of the storyboards there, put storyboard file and all of the connected view controllers together.
 
 ProjectName
  ├── _Resources // None-"code" files e.g. fonts, assets, sound files etc
  |   ├── Assets.xcassets
  |   └── Fonts
  |
  └── _Source
      ├── _Utilities // Files in this folder are PROJECT-AGNOSTIC (can be used across projects), i.e. not every protocol, extensions or global function should be in this folder.
      |   ├── Functions // Global functions
      |   ├── Protocols
      |   └── Extensions
      |
      ├── <Some Functionality Folder #1> // For example: Network, API, Data
      ├── <Some Functionality Folder #2>
      |
      ├── _UI
      |   ├── Design.swift // Contains design constants (colors, fonts etc)
      |   ├── _Components // This folder contains UI classes that are reused though the project
      |   |   ├── _Cells
      |   |   |   └── _<Some Cell>
      |   |   |       ├── SomeCell.swift
      |   |   |       └── SomeCell.xib
      |   |   └── <Some Other Component Group>
      |   |
      |   ├── _Screens //
      |   |   ├── LaunchScreen.storyboard
      |   |   ├── _Opening Screens // Contains Signup/Login Screens + any other stuff user sees once opening the app for the first time
      |   |   |   └── _Loading Screen // Loading screen is a copy of LaunchScreen with addition of loading indication and session/startup logic.
      |   |   |       ├── LoadingScreen.storyboard
      |   |   |       └── LoadingScreenViewController.swift
      |   |   |
      |   |   └── _Main Screens
      |   |       ├── _<Some Screen Group #1>
      |   |       |   ├── SomeScreenGroup1.storyboard
      |   |       |   ├── SomeViewController1.swift
      |   |       |   └── SomeViewController2.swift
      |   |       |
      |   |       └── _<Some Screen Group #2>
      |   |           ├── SomeScreenGroup1.storyboard
      |   |           ├── Some2ViewController3.swift
      |   |           ├── Some2ViewController4.swift
      |   |           └── Some2ViewController5.swift
      |   |
      |   ├── <Some-UI-Management-Class #1>.swift // 'Global' UI classes. For example "AlertsManager" that manages alert presentation.
      |   └── <Some-UI-Management-Class #2>.swift
      |
      └── _Supporting Files
          ├── Info.plist
          ├── AppDelegate.swift
          └── ProjectName-Bridging-Header.h
 */

