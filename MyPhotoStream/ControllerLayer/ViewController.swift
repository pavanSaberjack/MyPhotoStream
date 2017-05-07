//
//  ViewController.swift
//  MyPhotoStream
//
//  Created by Pavan on 06/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MPSAuthenticationVCDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var imagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesTableView.register(UINib(nibName: "MPSTableViewCell", bundle: nil), forCellReuseIdentifier: "DefaultCell")
        
//        imagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: )
        
//        self.randomPic()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if MPSConnectorManager.sharedInstance.isAuthenticated() == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                let authenticateVC: MPSAuthenticationVC = MPSAuthenticationVC(nibName: "MPSAuthenticationVC", bundle: nil)
                authenticateVC.delegate = self
                self.present(authenticateVC, animated: true) {
                    // something
                }
            }
        } else {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func hello() {
        print("Authentication complete")
        MPSConnectorManager.sharedInstance.status = true        
        self.dismiss(animated: true) {
            // do anyting
            
//            self.randomPic()
        }
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DefaultCell"
        let cell: MPSTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MPSTableViewCell
        cell.nameLabel?.text = "Image"
        return cell
    }
    
    // MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    
}

