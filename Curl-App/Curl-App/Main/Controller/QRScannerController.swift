//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController {

//    @IBOutlet var messageLabel:UILabel!
//    @IBOutlet var topbar: UIView!
    
//    var messageLabel: UILabel!
//    var topbar: UIView!

    
//    var captureSession = AVCaptureSession()
    
    /// 二维码扫描回调
    public var callback: ((_ id: String) -> Void)?
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession = AVCaptureSession()
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
//        view.bringSubviewToFront(messageLabel)
//        view.bringSubviewToFront(topbar)
        self.view.addSubview(topbar)
        self.view.addSubview(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        messageLabel = nil
//        topbar = nil
        captureSession = nil
        videoPreviewLayer?.delegate = nil
        videoPreviewLayer = nil
        qrCodeFrameView = nil
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeButtonAction() {
        self.dismiss(animated: true) {}
    }
    
    // MARK: - Helper methods

    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
//        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let alertPrompt = UIAlertController(title: "Scan result",
                                            message: decodedURL,
                                            preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm",
                                          style: UIAlertAction.Style.default,
                                          handler:
        { (action) -> Void in
            
//            if let url = URL(string: decodedURL) {
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url)
//                }
//            }
            
            self.dismiss(animated: true) {
                self.callback!(decodedURL)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
  private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
    layer.videoOrientation = orientation
    videoPreviewLayer?.frame = self.view.bounds
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if let connection =  self.videoPreviewLayer?.connection  {
      let currentDevice: UIDevice = UIDevice.current
      let orientation: UIDeviceOrientation = currentDevice.orientation
      let previewLayerConnection : AVCaptureConnection = connection
      
      if previewLayerConnection.isVideoOrientationSupported {
        switch (orientation) {
        case .portrait:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        case .landscapeRight:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
          break
        case .landscapeLeft:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
          break
        case .portraitUpsideDown:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
          break
        default:
          updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
          break
        }
      }
    }
  }

    // MARK: Lazy Load
    private lazy var topbar: UIView = {
        let view = UIView()
        view.frame = CGRect.init(x: 0,
                                 y: 0,
                                 width: UIScreen.main.bounds.size.width,
                                 height: 50)
        view.backgroundColor = UIColor.secondaryLabel
        
        // scan label
        let titleLabel = UILabel()
        titleLabel.text = "Scan"
        titleLabel.frame = CGRect.init(x: 0,
                                       y: 0,
                                       width: UIScreen.main.bounds.size.width,
                                       height: view.frame.size.height)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // close button
        let closeButton = UIButton.init(type: .system)
        closeButton.tintColor = UIColor.white
        closeButton.frame = CGRect.init(x: 8,
                                        y: 0,
                                        width: view.frame.size.height,
                                        height: view.frame.size.height)
        let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let largeSymbolImage = UIImage(systemName: "chevron.down.circle", withConfiguration: largeConfiguration)
        closeButton.setImage(largeSymbolImage, for: .normal)
        closeButton.setImage(UIImage.init(systemName: "chevron.down.circle.fill"),
                             for: .highlighted)
        view.addSubview(closeButton)
        closeButton.addTarget(self,
                              action: #selector(closeButtonAction),
                              for: .touchUpInside)
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No QR code is detected"
        label.textAlignment = .center
        label.textColor = .white
        
        var labelY = UIScreen.main.bounds.size.height - 80 - 30
        if #available(iOS 11.0, *) {
            let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
            if Int(bottomInset ?? 0) > 0 {
                labelY = labelY - bottomInset!
            }
        } else {
            
        }
        
        label.frame = CGRect.init(x: 0,
                                  y: labelY/*UIScreen.main.bounds.size.height-120*/,
                                  width: UIScreen.main.bounds.size.width,
                                  height: 70)
        label.backgroundColor = UIColor.secondaryLabel
        
        return label;
    }()
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
//            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}
