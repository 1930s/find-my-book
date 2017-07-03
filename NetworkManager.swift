//
//  NetworkManager.swift
//  FindMyBook
//
//  Created by Mrinalini Agarwal on 24/04/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static func parseSearch(term : String, closure: @escaping (_ response: Any?) -> Void) {
        
        print("In network manager") 
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        var dataTask: URLSessionDataTask?
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        let searchTerm = term.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(searchTerm)")
        
        
        dataTask = defaultSession.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            
            if error != nil {
                
                print(error!.localizedDescription)
                closure(nil)
                
            } else if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200 {
                    
                    if let bookDets = data {
                        let books = BookDetails.dataToBook(bookDets as Data?)
                        closure(books)
                    }
                    
                }
            }
        })
        
        dataTask?.resume()
        
    }
    
}
