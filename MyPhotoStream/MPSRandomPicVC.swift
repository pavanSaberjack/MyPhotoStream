//
//  MPSRandomPicVC.swift
//  MyPhotoStream
//
//  Created by Pavan on 07/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit

class MPSRandomPicVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.randomPic()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //
        }
    }
    
    func showRandomPic(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", error!)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }
                
                DispatchQueue.main.async {
                    self.imgView.image = UIImage(data: data!)
                }
            }.resume()
    }
    
    func randomPic() {
        let url = URL(string: "https://api.unsplash.com/photos/random")
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        request.addValue("Client-ID 947050e733a9cacb8c1c236bf3f673fac96c7248256073b223f36787a2bf3c98", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            //
            print(error as Any)
            print(response as Any)
            
            
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }
            
            if let responseJSON = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject]{
                
                let user = responseJSON["urls"] as? [String:AnyObject]
                let url = user?["regular"]
                self.showRandomPic(url as! String)
            }
        }
        task.resume()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
