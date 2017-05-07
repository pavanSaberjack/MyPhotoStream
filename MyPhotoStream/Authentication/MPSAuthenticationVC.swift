//
//  MPSAuthenticationVC.swift
//  MyPhotoStream
//
//  Created by Pavan on 06/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit


protocol MPSAuthenticationVCDelegate {
    func hello()
}

class MPSAuthenticationVC: UIViewController {

    var delegate :MPSAuthenticationVCDelegate?
    
    @IBOutlet private weak var userNameTxtField: UITextField!
    @IBOutlet private weak var passwordTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func authenticate(_ sender: UIButton) {
        if ((userNameTxtField.text?.characters.count)! > 0) && ((passwordTxtField.text?.characters.count)! > 0) {
            delegate?.hello()
        } else {
            print("Enter correct details")
        }
    }
    
    
    @IBAction func showRandomPic(_ sender: Any) {
        
        
        
        let randomPicVC: MPSRandomPicVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MPSRandomPicVC") as! MPSRandomPicVC
        self.present(randomPicVC, animated: true, completion: nil)
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
