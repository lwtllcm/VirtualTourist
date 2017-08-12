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
            
            private init() {}
        }
        return Singleton.sharedInstance
    }
    
    func getPhotos(selectedLatitude: String, selectedLongitude: String, page: Int, completionHandlerForGET:@escaping (_ result: AnyObject?, _ error:NSError?) -> Void) -> URLSessionDataTask {
        print("getPhotos")
        
        
        let session = URLSession.shared
        
        
        var bboxString = "lon="
        var bboxSelectedLongitude:NSString = selectedLongitude as NSString
        
        bboxString = bboxString + (bboxSelectedLongitude as String)
        
        bboxString = bboxString + "&lat="
        
        var bboxSelectedLatitude:NSString = selectedLatitude as NSString
        
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
        
        
        var flickrSearchURL = NSURL(string: flickrSearchURLString)!
        print(" ")
        print("flickrSearchURL", flickrSearchURL)
        
        //let request = NSMutableURLRequest(url: flickrSearchURL as URL)
        let request = URLRequest(url: flickrSearchURL as URL)

        print(" ")
        print(request)
        print(" ")
        
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            
            
            func displayError(error: String) {
                print(error)
            }
            
            guard (error == nil) else {
                
                print("There was an error with your request: \(String(describing: error?.localizedDescription))")
                return
            }
            /*
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                
                print("Your request returned a status code other than 2xx!")
                return
            }
            */
            guard data != nil else {
                
                print("No data was returned by the request!")
                
                return
            }
            
            print("ready for convertData")
           //self.convertDataWithCompletionHandler(data: data! as NSData, completionHandlerForConvertData: completionHandlerForGET as! (Any?, NSError?) -> Void)
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForGET )
            
            print("data returned")
            
            
        }
        
        
        task.resume()
        return task
    }
    
   // private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (AnyObject?, NSError?) -> Void) {
    //private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (Any?, NSError?) -> Void) {
    
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {

        print("convertDataWithCompletionHandler")
        //var parsedResult: AnyObject!
        //var parsedResult: Any!
        var parsedResult: [String:AnyObject]!
        
        do {
            
            parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:AnyObject]
            print("parsedResult", parsedResult)
            
            
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        //completionHandlerForConvertData(parsedResult as AnyObject?, nil)
        
        completionHandlerForConvertData(parsedResult as AnyObject?, nil)
        
    }
    
}
