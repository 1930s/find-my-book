//
//  BookDetails.swift
//  FindMyBook
//
//  Created by Mrinalini Agarwal on 24/04/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import Foundation

class BookDetails {
    var title = ""
    var authors = ""
    var image = ""
    var saleability = ""
    var amount = 0
    var currencyCode = ""
    
    convenience init(title : String, authors : String, image : String, saleability : String, amount : Int, currencyCode : String) {
        self.init()
        self.title = title
        self.authors = authors
        self.image = image
        self.saleability = saleability
        self.amount = amount
        self.currencyCode = currencyCode
    }
    
    
    static func dataToBook(_ data : Data?) -> BookDetails? {
        
        
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                if let items = response["totalItems"] as? Int {
                    if (items == 1)  {
                        var title = ""
                        var authors = ""
                        var image = ""
                        var saleability = ""
                        var amount = 0
                        var currencyCode = ""
                        if  let books = response["items"] as! [AnyObject]? {
                            let bookDetails = books[0]
                            if let bookDets = bookDetails as? [String: AnyObject] {
                                if let volumeInfo = bookDets["volumeInfo"] as? [String: AnyObject] {
                                     title = (volumeInfo["title"] as? String)!
                                    print(title)
                                    if let s : String = (volumeInfo["authors"] as? String) {
                                     authors = s
                                        print(authors)

                                    }
                                }
                                if let saleInfo = bookDets["saleInfo"] as? [String: AnyObject] {
                                     saleability = (saleInfo["saleability"] as? String)!
                                    let saleTrue = "FOR_SALE"
                                    if (saleability == saleTrue) {
                                        amount = ((saleInfo["amount"]) as? Int)!
                                        print(amount)

                                        currencyCode = ((saleInfo["currencyCode"]) as? String)!
                                        print(currencyCode)

                                    }
                                }
                                if let volumeInfo = bookDets["volumeInfo"] as? [String: AnyObject] {
                                    if let imageLinkss = volumeInfo["imageLinks"] as? [String: AnyObject] {
                                         image = (imageLinkss["smallThumbnail"] as? String)!
                                        print(image)
                                    }
                                }
                            }
                        }
                        return BookDetails(title: title, authors: authors, image: image, saleability: saleability, amount: amount, currencyCode: currencyCode)
                        
                    }
                    if (items == 0) {
                        return BookDetails(title: "Book not found!" , authors: "", image: "https://images-na.ssl-images-amazon.com/images/G/01/img14/books/icons/11753_books_holiday-branding-icon-evergreen-04.jpg",saleability: "",amount: 0, currencyCode: "")
                    }
                    
                }
            }
        }
        catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        return nil
    }
    
}





