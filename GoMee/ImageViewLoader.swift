//
//  UIImageView.swift
//  GoMee
//
//  Created by Jaxon Stevens on 2/10/17.
//  Copyright © 2017 Jaxon Stevens. All rights reserved.
//
import Foundation
import UIKit

class EKImageLoader:NSObject,NSURLConnectionDelegate, NSURLConnectionDataDelegate
{
    
    var imageData : NSMutableData = NSMutableData()
    var imageView:UIImageView!
    var imageView2: UIImageView!
    
    func getImageFromUrl(_ urlString:NSString!,imageView:UIImageView!)  {
        self.imageView=imageView;
        imageData=NSMutableData()
        let url : URL = URL(string: urlString as String)!
        let request : NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.addValue("image/*",forHTTPHeaderField: "Accept")
        let connection : NSURLConnection!=NSURLConnection(request: request as URLRequest, delegate: self)
        connection.start()
    }
    
    func getImageFromUrl(_ urlString:NSString!,imageView2:UIImageView!)  {
        self.imageView=imageView2;
        imageData=NSMutableData()
        let url : URL = URL(string: urlString as String)!
        let request : NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.addValue("image/*",forHTTPHeaderField: "Accept")
        let connection : NSURLConnection!=NSURLConnection(request: request as URLRequest, delegate: self)
        connection.start()
    }
    
    

    
    
     func connection(_ _connection: NSURLConnection!,
        didReceive response: URLResponse) {
            print("NSURLConnection didReceiveResponse");
    }
     func connection(_ _connection:NSURLConnection!,didFailWithError error:Error)
    {
        print("NSURLConnection didFailWithError")
    }
     func connection(_ connection : NSURLConnection!, didReceive data:Data)
    {
        print("NSURLConnection didReceiveData")
        self.imageData.append(data)
    }
     func connectionDidFinishLoading(_ connection : NSURLConnection!)
    {
        print("NSURLConnection connectionDidFinishLoading")
        self.imageView.image=UIImage(data:self.imageData as Data)
    }

    
}

extension UIImageView {
    
    func setImageFromUrl(_ urlString:NSString!)
    {
        let imageLoader=EKImageLoader()
        imageLoader.getImageFromUrl(urlString, imageView: self)
        imageLoader.getImageFromUrl(urlString, imageView2: self)

        

    }
    
    
}
