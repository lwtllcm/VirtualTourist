//
//  GetPhotos.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 7/24/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class GetPhotos  {
    
    var session = NSURLSession.sharedSession()
    
    
    class  func sharedInstance() -> GetPhotos {
        struct Singleton {
            static let sharedInstance = GetPhotos()
            
            private init() {}
        }
        return Singleton.sharedInstance
    }

    func getPhotos(selectedLatitude: String, selectedLongitude: String, completionHandlerForGET:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        print("getPhotos")
        
        
        let session = NSURLSession.sharedSession()
        
        //let flickrSearchURL = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&bbox=-123.8587455078125,46.35308398800007,bbox=-123.8587455078125,46.35308398800007,48.587958419830336&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1&per_page=5")!
        
        var bboxString = "lon="
        var bboxSelectedLongitude:NSString = selectedLongitude
        print(bboxSelectedLongitude)
        
        bboxString = bboxString + (bboxSelectedLongitude as String)
        
        bboxString = bboxString + "&lat="
        
        // -123.8587455078125&lat="
        
        var bboxSelectedLatitude:NSString = selectedLatitude
        // var bboxSelectedLatitude = ((selectedLatitude as NSString) as String)
        print(bboxSelectedLatitude)
        bboxString = bboxString + (bboxSelectedLatitude as String)
        
        
        var flickrSearchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&"
        flickrSearchURLString = flickrSearchURLString + bboxString
        flickrSearchURLString = flickrSearchURLString + "&radius=20&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1&per_page=5"
        print(" ")
        print("flickrSearchURLString", flickrSearchURLString)
        
        
        var flickrSearchURL = NSURL(string: flickrSearchURLString)!
        print(" ")
        print("flickrSearchURL", flickrSearchURL)
        
        let request = NSMutableURLRequest(URL: flickrSearchURL)
        print(" ")
        print(request)
        
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            
            
            func displayError(error: String) {
                print(error)
            }
            
            guard (error == nil) else {
                //displayError("There was an error with your request: \(error)")
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                //displayError("Your request returned a status code other than 2xx!")
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            guard data != nil else {
                //displayError("No data was returned by the request!")
                print("No data was returned by the request!")
                
                return
            }
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForGET)
            print("data returned")
            
            
        }
        
        
        task.resume()
        return task
    }
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        print("convertDataWithCompletionHandler")
        var parsedResult: AnyObject!
        
        do {
            
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
        
    }

}
