//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/16/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let stack = CoreDataStack(modelName: "Model")!
    
   // var flickrPhotos = [FlickrPhotos]()
    
    //Key:
    //d590bf9e37f0415994f25fa25cc23dc7
    
    //Secret:
    //1fd1f35797a94d19
    
    //var returnedPhotosArray  = []
    var returnedPhotosArray:NSMutableArray  = []
    
    

    var sharedSession = URLSession.shared

 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        stack.autoSave(20)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        do {
            try stack.saveContext()
        }catch{
            print("error while saving")
        }
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        do {

            try stack.saveContext()
        }catch{
            print("error while saving")
        }    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

