//
//  ViewController.swift
//  FindMyBook
//
//  Created by Mrinalini Agarwal on 14/04/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "FindMyBook"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func infoButton(_ sender: Any) {
        
    }
    
    
    @IBAction func cancelToMain(segue : UIStoryboardSegue) {
            
    }
    
    @IBAction func foundToMainMenu(segue : UIStoryboardSegue) {
    }
    
    @IBAction func unwindToMain (unwindSegue : UIStoryboardSegue){
        
    }

}

