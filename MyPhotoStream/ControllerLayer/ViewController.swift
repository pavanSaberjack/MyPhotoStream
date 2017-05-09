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
    
    var imagesArray : [MPSImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesTableView.backgroundColor = DEFAULT_BACKGROUND_COLOR
        imagesTableView.register(UINib(nibName: "MPSTableViewCell", bundle: nil), forCellReuseIdentifier: "DefaultCell")
//        imagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: )

        self.imagesArray = MPSDataManager.sharedInstance.getImagesList()
        if self.imagesArray.count == 0 {
            MPSConnectorManager.sharedInstance.getPhotosList { (images, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    let arr : [MPSImage] = images!
                    self.imagesArray.append(contentsOf: arr)
                    self.imagesTableView.reloadData()
                }
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
        return self.imagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "DefaultCell"
        let cell: MPSTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MPSTableViewCell
        cell.contentView.bringSubview(toFront: cell.nameLabel)
        
        let imageObj: MPSImage = self.imagesArray[indexPath.row]
        
        cell.nameLabel?.text = imageObj.name
        cell.smallDescriptionLabel.text = imageObj.smallDescription
        cell.imgView?.image = nil
        
        if imageObj.image == nil {            
            // download Image
            downloadImage(imageObj.downloadURLStr!, imageObj)
        } else {
            let image: UIImage = imageObj.image as! UIImage
            cell.imgView?.image = image
        }        
        return cell
    }
    
    func downloadImage(_ url: String, _ imageObject: MPSImage) {
        MPSDataManager.sharedInstance.downloadImage(imageObject) { (updatedObj) in
            if updatedObj == nil || updatedObj?.image == nil {
                print()
                return
            }
            
            DispatchQueue.main.async {
                let objIndex: Int = self.imagesArray.index(of: imageObject)!
                self.imagesArray[objIndex] = updatedObj!
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}

