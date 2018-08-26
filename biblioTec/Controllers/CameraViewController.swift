//
//  CameraViewController.swift
//  biblioTec
//
//  Created by Ricardo Ramirez on 8/26/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    var stringURL = String()
    
    enum error: Error {
        case noCameraAvailable
        case videoInput
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        performSegue(withIdentifier: "backToMenu", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 10
        do {
            try scanQRCode()
        } catch {
            print("Failed to scan the QR")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                stringURL = machineReadableCode.stringValue!
                print("QR CODE-------:\(stringURL)") //FLAGGGG <--------------------------------------------------------
            }
        }
    }
    
    func scanQRCode() throws {
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("no camera")
            throw error.noCameraAvailable
        }
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("failed to init camera")
            throw error.videoInput
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.frame.size = cameraView.layer.bounds.size
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        avCaptureSession.startRunning()
    }
}







