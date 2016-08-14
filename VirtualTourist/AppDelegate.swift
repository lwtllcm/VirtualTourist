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
    
    var returnedPhotosArray  = []
    

    var sharedSession = NSURLSession.sharedSession()

 
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        print(paths[0])
        
        stack.autoSave(20)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        do {
            try stack.saveContext()
        }catch{
            print("error while saving")
        }
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        do {

            try stack.saveContext()
        }catch{
            print("error while saving")
        }    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {

    }

    func applicationWillTerminate(application: UIApplication) {

    }


}

