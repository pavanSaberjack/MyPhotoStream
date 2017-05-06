//
//  MPSConnectorManager.swift
//  MyPhotoStream
//
//  Created by Pavan on 06/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit


class MPSConnectorManager: NSObject {
    
    static let sharedInstance: MPSConnectorManager = MPSConnectorManager()
    public var status: Bool = false;
    
    let applicationID : String = "947050e733a9cacb8c1c236bf3f673fac96c7248256073b223f36787a2bf3c98"
    let secret : String = "52360c281b44cb79f9b5f549f414472fd9c2a7c4fbec3df3758d5c6081e8a3e6"
    let authorizeCallbackURL : String = "urn:ietf:wg:oauth:2.0:oob"
    
    func isAuthenticated() -> Bool {
        return self.status
    }
}

