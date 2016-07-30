//
//  FlickrPhotos.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 6/21/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

//VirtualTourist



class FlickrPhotos {
    
    var session = NSURLSession.sharedSession()

    
    //let request = NSMutableURLRequest(URL:NSURL(string: "https://www.flickr.com/photos")!)
    //var session = NSURLSession.sharedSession()
    //let session = NSURLSession()
    
    func getPhotos(completionHandlerForGet:(result:AnyObject!, error:NSError)? -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL:NSURL(string: "https://www.flickr.com/photos")!)
        //var session = NSURLSession.sharedSession()
        /*
        let task =  session.dataTaskWithRequest(request) {data, response, error in
            print(response)
            var parsedResult: AnyObject!
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            */
        
            let task = session.dataTaskWithRequest(request)
            return task
        }
    }
