//
//  SafariExtensionHandler.swift
//  goodlink Extension
//
//  Created by Ratik Sharma on 16/09/19.
//  Copyright © 2019 Ratik Sharma. All rights reserved.
//

import SafariServices

// https://github.com/otzbergnet/libHelper/blob/master/Open%20Access%20Helper%20Safari/SafariExtensionHandler.swift

class SafariExtensionHandler: SFSafariExtensionHandler {
    var isbn = ""
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        if (messageName == "BookPage") {
            enableToolbar()
            if let message = userInfo {
                self.isbn = message["isbn"] as! String
            }
        } else if (messageName == "NotABookPage") {
            disableToolbar()
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        let bookRequest = BookRequest(isbn: self.isbn)
        bookRequest.getBookUrl { result in
            switch result {
            case .failure(_):
                NSLog("Failed to get Book URL")
            case .success(let url):
                self.openGoodreads(window: window, url: url)
            }
        }
    }

    func openGoodreads(window: SFSafariWindow, url: String) {
        window.getActiveTab { activeTab in
            activeTab?.getActivePage { activePage in
                activePage?.getPropertiesWithCompletionHandler( { properties in
                    activePage?.dispatchMessageToScript(withName: "OpenGR", userInfo: ["url": url])
                })
            }
        }
    }
    
    func fetchBookUrl(window: SFSafariWindow) {
        let API_KEY = "CySWpMKIMy8hbEhfMicvQ"
        let resourceString = "https://www.goodreads.com/book/isbn_to_id?key=\(API_KEY)&isbn=\(self.isbn)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        let task = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            if let rawData = data {
                let id = String(decoding: rawData, as: UTF8.self)
                    .components(separatedBy: "\n")
                    .first!
                let showURL = "https://www.goodreads.com/book/show/\(id)"
                self.openGoodreads(window: window, url: showURL)
            }
        }
        task.resume()
    }
    
    func enableToolbar() {
        SFSafariApplication.getActiveWindow { (window) in
            window?.getToolbarItem { $0?.setEnabled(true) }
        }
    }
    
    func disableToolbar() {
        SFSafariApplication.getActiveWindow { (window) in
            window?.getToolbarItem { $0?.setEnabled(false) }
        }
    }
}
