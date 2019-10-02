//
//  SafariExtensionViewController.swift
//  goodlink Extension
//
//  Created by Ratik Sharma on 16/09/19.
//  Copyright © 2019 Ratik Sharma. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
