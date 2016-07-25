//
//  GetImage.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 7/24/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation


class GetImage {
    
    var session = NSURLSession.sharedSession()
    
    
    class  func sharedInstance() -> GetImage {
        struct Singleton {
            static let sharedInstance = GetImage()
            
            private init() {}
        }
        return Singleton.sharedInstance
    }
    
func getImage(photoURLString:NSString) -> NSURLSessionDataTask {
    print("getImage")
    
    
    //let session = NSURLSession.sharedSession()
    
    
    
    //let request = NSMutableURLRequest(URL: NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&bbox=-123.8587455078125,46.35308398800007,-120.5518607421875,48.587958419830336&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1&per_page=5")!)
    
    //print(request)
    
    let thisPhotoURL = NSURL(string:photoURLString as String)
    
    let task = session.dataTaskWithURL(thisPhotoURL!) {(data, response, error) in
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
        
        guard let data = data else {
            //displayError("No data was returned by the request!")
            print("No data was returned by the request!")
            
            return
        }
        print("image returned")
        
        
        //self.returnedPhotosArray.addObject(data)
        //print(self.returnedPhotosArray.count)
        
        
    }
    
    
    task.resume()
    return task
}

}
