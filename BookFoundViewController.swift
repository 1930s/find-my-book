//
//  BookFoundViewController.swift
//  FindMyBook
//
//  Created by Mrinalini Agarwal on 25/04/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class BookFoundViewController : UIViewController  {
   
var newBook : BookDetails?
    override func viewDidLoad() {
        print(newBook)
        setBookDetails(book: newBook!)
    }

    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var authors: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var currency: UILabel!
    
    func setBookDetails(book : BookDetails) {
        print(book.title)
        text.text = book.title
        print(book.authors)
        authors.text = book.authors
        downloadImage(url: (NSURL(string : ("http://books.google.com/books/content?id=ll_Z8BDdFh0C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api")) as! URL))
        if let amountt = book.amount as Int? {
            price.text = String(amountt)
        }
        currency.text = book.currencyCode
        
    }
    
//    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
//        URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//            completion(data, response, error)
//            }.resume()
//    }
//    
//    func downloadImage(url: URL) {
//        getDataFromUrl(url: url) { (data, response, error)  in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            DispatchQueue.main.async() { () -> Void in
//                image.image = UIImage(data: data.image)
//            }
//        }
//    }
//    func downloadImage(urlString:String) {
//        
//        let imgURL: NSURL = NSURL(string: urlString)!
//        let request: NSURLRequest = NSURLRequest(url: imgURL as URL)
//        NSURLConnection.sendAsynchronousRequest(
//            request as URLRequest, queue: OperationQueue.main,
//            completionHandler: {(response: URLResponse?, data: Data?, error: Error?) -> Void in
//                if error == nil {
//                    image.image = UIImage(data: data!)
//                }
//        })
//        
//    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
                self.image.image = UIImage(data: data)
            }
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToFoundScreen" {
//            if let bookViewInstance = segue.source as? BarcodeReaderViewController {
//                newBook = bookViewInstance.newBookFromBarcode
//            }
//        }
//    }
}
