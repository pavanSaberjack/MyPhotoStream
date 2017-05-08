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
        self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR
        
        updateUI(self.userNameTxtField)
        updateUI(self.passwordTxtField)
        
        // Do any additional setup after loading the view.
    }
    
    func updateUI(_ textField: UITextField ) {
        let backGroundColor: UIColor = UIColor.init(colorLiteralRed: (243.0/255.0), green: (245.0/255.0), blue: (247.0/255.0), alpha: 1.0)
        let borderColor: UIColor = UIColor.init(colorLiteralRed: (228.0/255.0), green: (232.0/255.0), blue: (237.0/255.0), alpha: 1.0)
        
        textField.backgroundColor = backGroundColor
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
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
