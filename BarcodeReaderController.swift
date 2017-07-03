//
//  BarcodeReader.swift
//  FindMyBook
//
//  Created by Mrinalini Agarwal on 24/04/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import AVFoundation


class BarcodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var newBookFromBarcode : BookDetails?
    @IBAction func foundToScanAgain(segue : UIStoryboardSegue) {
    }
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a session object
        captureSession = AVCaptureSession()
        
        // set the capture device
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Create input object
        let videoInput : AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
            // Add input to the session
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            }
        }
        catch {
            print("ERROR")
            scanningError()
            return
        }
        
        
        // Create output object.
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session.
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode type for which to scan: EAN-13.
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode]
            
        } else {
            scanningError()
        }
        
        // Add previewLayer and have it show the video data.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.visibleRect
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer!);
        
        // Begin the capture session.
        
        captureSession.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func scanningError() {
        // Let the user know that scanning isn't possible with the current device.
        let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        captureSession = nil
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods

    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
//         Get the first object from the metadataObjects array.
                if let barcodeData = metadataObjects.first {
                    // Turn it into machine readable code
                    let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject;
                    if let readableCode = barcodeReadable {
                        // Send the barcode as a string to barcodeDetected()
                        print(readableCode.stringValue)
                        barcodeDetected(code: readableCode.stringValue)
                    }
        
                    // Vibrate the device to give the user some feedback.
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

                    // Avoid a very buzzy device.
                    captureSession.stopRunning()
//                    self.performSegue(withIdentifier: "goToFoundScreen" , sender: self)

                }
        
    }
    

    func barcodeDetected(code: String) {
        
        // Let the user know we've found something.
//        let alert = UIAlertController(title: "Found a Barcode!", message: code, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.destructive, handler: { action in
//            
//            
//            
//
//            }))
//        self.present(alert, animated: true, completion: nil)

        // Remove the spaces.
        let trimmedCode = code.trimmingCharacters(in:NSCharacterSet.whitespaces)
        
        let trimmedCodeString = "\(trimmedCode)"
        print(trimmedCodeString)
        NetworkManager.parseSearch(term: trimmedCodeString, closure: { (books) in
            
            if (books != nil) {
                print(books)
                self.newBookFromBarcode = books as! BookDetails?
                self.performSegue(withIdentifier: "goToFoundScreen", sender: self)
            }
            
        })
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFoundScreen" {
            if let dest = segue.destination as? BookFoundViewController {
                print(newBookFromBarcode?.title)
                print(newBookFromBarcode?.authors)
                dest.newBook = newBookFromBarcode
            }
        }
    }
    


//    func downloadImage(urlString:String) {
//        
//        var imgURL: NSURL = NSURL(string: urlString)!
//        let request: NSURLRequest = NSURLRequest(url: imgURL as URL)
//        NSURLConnection.sendAsynchronousRequest(
//            request as URLRequest, queue: OperationQueue.main,
//            completionHandler: {(response: URLResponse!,data: Data!,error: Error!) -> Void in
//                if error == nil {
//                    image.image = UIImage(data: data)
//                }
//        } as! (URLResponse?, Data?, Error?) -> Void)
//        
//    }
}
