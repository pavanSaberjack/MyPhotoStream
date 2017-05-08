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
    
    var imagesDict: [String: UIImage] = [:]
    var imageURLsArray: Array<String> = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesTableView.register(UINib(nibName: "MPSTableViewCell", bundle: nil), forCellReuseIdentifier: "DefaultCell")
//        imagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: )
        
        MPSConnectorManager.sharedInstance.getPhotosList { (images, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                let arr : [String] = images!
                self.imageURLsArray.append(contentsOf: arr)
                self.imagesTableView.reloadData()
            }
        }
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
        }
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageURLsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DefaultCell"
        let cell: MPSTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MPSTableViewCell
        cell.nameLabel?.text = "Image"
        
        if imagesDict[String(indexPath.row)] == nil {
            cell.imgView?.image = nil
            // download Image
            downloadImage(imageURLsArray[indexPath.row], String(indexPath.row))
        } else {
            let image: UIImage = self.imagesDict[String(indexPath.row)]!
            cell.imgView?.image = image
        }
        
        return cell
    }
    
    func downloadImage(_ url: String, _ key: String) {
        MPSConnectorManager.sharedInstance.downloadPic(url) { (image, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.imagesDict[key] = image
                self.imagesTableView.reloadData()
            }
        }
    }
    
    // MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

