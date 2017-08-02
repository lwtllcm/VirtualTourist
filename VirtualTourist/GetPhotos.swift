//
//  GetPhotos.swift
//  VirtualTourist
//
//  Created by Laurie Wheeler on 7/24/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class GetPhotos  {
    
    var session = URLSession.shared
    
    
    class  func sharedInstance() -> GetPhotos {
        struct Singleton {
            static let sharedInstance = GetPhotos()
            
            fileprivate init() {}
        }
        return Singleton.sharedInstance
    }

    func getPhotos(_ selectedLatitude: String, selectedLongitude: String, page: Int, completionHandlerForGET:@escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        print("getPhotos")
        
        
        let session = URLSession.shared
        
        
        var bboxString = "lon="
       // var bboxSelectedLongitude:NSString = selectedLongitude as NSString
        
        var bboxSelectedLongitude = selectedLongitude
        
        bboxString = bboxString + (bboxSelectedLongitude as String)
        
        bboxString = bboxString + "&lat="
        
        //var bboxSelectedLatitude:NSString = selectedLatitude as NSString
        
        var bboxSelectedLatitude = selectedLatitude 

        bboxString = bboxString + (bboxSelectedLatitude as String)
        
        var flickrPageString = "&page="

        var flickrPageNumString = String(page)
        flickrPageString = flickrPageString + (flickrPageNumString)
        
        
        var flickrSearchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d590bf9e37f0415994f25fa25cc23dc7&"
        flickrSearchURLString = flickrSearchURLString + bboxString
        flickrSearchURLString = flickrSearchURLString + flickrPageString
        flickrSearchURLString = flickrSearchURLString + "&radius=20&accuracy=1&safe_search=1&extras=url_m&format=json&nojsoncallback=1&per_page=20"
        print(" ")
        print("flickrSearchURLString", flickrSearchURLString)
        
        
        var flickrSearchURL = URL(string: flickrSearchURLString)!
        print(" ")
        print("flickrSearchURL", flickrSearchURL)
        
        let request = NSMutableURLRequest(url: flickrSearchURL)
        print(" ")
        print(request)
        
     //   let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
                
            func displayError(_ error: String) {
                print(error)
            }
            
            guard (error == nil) else {

                print("There was an error with your request: \(error)")
                return
            }
            
          //  guard let statusCode = (response as? HTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            
            if ((((response as? HTTPURLResponse)?.statusCode)!  < 200 ) ){

                print("Your request returned a status code lower than 2xx!")
                return
            }
                
                if ((((response as? HTTPURLResponse)?.statusCode)!  > 200 ) ){
                    
                    print("Your request returned a status code lower than 2xx!")
                    return
                }

            
            guard data != nil else {

                print("No data was returned by the request!")
                
                return
            }
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForGET)
            print("data returned")
            
            
        }
        
        
        task.resume()
        return task
    }
    
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        print("convertDataWithCompletionHandler")
        var parsedResult: AnyObject!
        
        do {
            
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
        
    }

}
