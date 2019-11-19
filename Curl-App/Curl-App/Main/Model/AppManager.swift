//
//  CAShared.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/5.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    static let shared = AppManager()
    
    public var curl: String!
    
    override init() {
        super.init()
    }
    
    
}
