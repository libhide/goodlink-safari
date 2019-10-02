//
//  BookRequest.swift
//  goodlink Extension
//
//  Created by Ratik Sharma on 02/10/19.
//  Copyright © 2019 Ratik Sharma. All rights reserved.
//

import Foundation

enum BookError: Error {
    case noDataAvailable
}

struct BookRequest {
    let resourceUrl: URL
    let API_KEY = "CySWpMKIMy8hbEhfMicvQ"
    
    init(isbn: String) {
        let resourceString = "https://www.goodreads.com/book/isbn_to_id?key=\(API_KEY)&isbn=\(isbn)"
        guard let fetchURL = URL(string: resourceString) else {fatalError()}
        self.resourceUrl = fetchURL
    }
    
    func getBookUrl(completion: @escaping (Result<String, BookError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceUrl) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            guard let id = String(decoding: jsonData, as: UTF8.self)
                .components(separatedBy: "\n")
                .first else {
                    completion(.failure(.noDataAvailable))
                    return
            }
            
            let showURL = "https://www.goodreads.com/book/show/\(id)"
            completion(.success(showURL))
        }
        dataTask.resume()
    }
}
