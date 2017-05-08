//
//  MPSRandomPicVC.swift
//  MyPhotoStream
//
//  Created by Pavan on 07/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit

//import "MPSContstants.Swift"

class MPSRandomPicVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        MPSConnectorManager.sharedInstance.getRandomPic { (image, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.imgView.image = image
            }
        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
