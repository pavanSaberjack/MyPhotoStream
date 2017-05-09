//
//  MPSConnectorManager.swift
//  MyPhotoStream
//
//  Created by Pavan on 06/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit


class MPSConnectorManager: NSObject {
    
    let randomPicURLString: String = "https://unsplash.it/200/300/?random"
    
    static let sharedInstance: MPSConnectorManager = MPSConnectorManager()
    public var status: Bool = true;
    
    let applicationID : String = "947050e733a9cacb8c1c236bf3f673fac96c7248256073b223f36787a2bf3c98"
    let secret : String = "52360c281b44cb79f9b5f549f414472fd9c2a7c4fbec3df3758d5c6081e8a3e6"
    let authorizeCallbackURL : String = "urn:ietf:wg:oauth:2.0:oob"
    
    func isAuthenticated() -> Bool {
        return self.status
    }
    
    func getRandomPic(completion: @escaping (UIImage?, Error?) -> Swift.Void ) {
        
        let image: UIImage? = nil
        
        let url = URL(string: "https://api.unsplash.com/photos/random")
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        request.addValue("Client-ID 947050e733a9cacb8c1c236bf3f673fac96c7248256073b223f36787a2bf3c98", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    completion(image, error)
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                DispatchQueue.main.async {
                    completion(image, error)
                }
                return
            }
            
            if let responseJSON = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject]{
                
//                let links = responseJSON["links"] as? [String:AnyObject]
//                let downloadLink = links?["download_location"]
                
                let urls = responseJSON["urls"] as? [String:AnyObject]
                let url = urls?["regular"]
                self.showRandomPic(url as! String, completionHandler: completion)
            }
        }
        task.resume()
    }
    
    func showRandomPic(_ urlString: String, completionHandler: @escaping (UIImage?, Error?) -> Swift.Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", error!)
                    completionHandler(nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    completionHandler(nil, error)
                    return
                }
            
                completionHandler(UIImage(data: data!), error)
            }.resume()
    }
    
    func getPhotosList(completionHandler: @escaping ([MPSImageObj]?, Error?) -> Swift.Void) {
        let url = URL(string: "https://api.unsplash.com/photos")
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        request.addValue("Client-ID 947050e733a9cacb8c1c236bf3f673fac96c7248256073b223f36787a2bf3c98", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let responseJSON = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [AnyObject]

            let imagesArray: Array<MPSImageObj> = MPSDataManager.sharedInstance.saveImages(responseJSON!)
            DispatchQueue.main.async {
                completionHandler(imagesArray, error)
            }
        }.resume()
    }

    func downloadPic(_ urlString: String, completionHandler: @escaping (UIImage?, Error?) -> Swift.Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error!)
                completionHandler(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                completionHandler(nil, error)
                return
            }
            
            completionHandler(UIImage(data: data!), error)
            }.resume()
    }
    
}

