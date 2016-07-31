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
    
    func preloadData() {
        /*
        do {
            try stack.dropAllData()
        }catch{
            print("Error dropping all objects in DB")
        }
        */
              
        //let pinLosAngeles = Pin(entity: "Los Angeles", insertIntoManagedObjectContext: stack.context)
        
        let pinLosAngeles = Pin(location: "Los Angeles", latitude: "33.955190025712511", longitude: "-118.07473099889084", context: stack.context)
        
       // pinLosAngeles.location = "LosAngeles"
       // pinLosAngeles.latitude = "33.955190025712511"
       // pinLosAngeles.longitude = "-118.07473099889084"
        
        print("pinLosAngeles", pinLosAngeles)

    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //preloadData()
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        print(paths[0])
        
        stack.autoSave(30)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        do {
           // try stack.save()
            try stack.saveContext()
        }catch{
            print("error while saving")
        }
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        do {
            //try stack.save()
            try stack.saveContext()
        }catch{
            print("error while saving")
        }    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

