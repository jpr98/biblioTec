//
//  CameraViewController.swift
//  biblioTec
//
//  Created by Ricardo Ramirez on 8/26/18.
//  Copyright © 2018 Juan Pablo Ramos. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

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
                // prepare json data
                let json: [String: Any] = ["updated": 0]
                let id = UserDefault.defaults.string(forKey: "user")!
                
                let jsonData = try? JSONSerialization.data(withJSONObject: json)

                // create post request
                let url = URL(string: "\(stringURL)/\(id)")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue(" application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")

                // insert json data to the request
                request.httpBody = jsonData

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                }
                task.resume()
				
				let alertController = UIAlertController(title: "Código Escaneado", message: "Gracias por ayudarnos a hacer la biblioteca un mejor lugar para todos!", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
					UserDefault.makingReservation()
					self.unwind()
				}))
				present(alertController, animated: true, completion: nil)
				
            }
        }
    }

	func unwind() {
		self.performSegue(withIdentifier: Constants.SegueIdenfiers.endedScanning, sender: self)
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
