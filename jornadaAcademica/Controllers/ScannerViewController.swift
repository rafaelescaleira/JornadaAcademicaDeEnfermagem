//
//  ScannerViewController.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 30/08/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit
import AVFoundation
import BetterSegmentedControl

class ScannerViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var stopCameraView: UIView!
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cpfLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var stateButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var captureDeviceInput: AVCaptureInput?
    var captureMetadataOutput: AVCaptureMetadataOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var person: PersonsDatabase?
    var day: Int = 18
    
    private let supportedCodeTypes = [
        AVMetadataObject.ObjectType.upce,
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
        AVMetadataObject.ObjectType.qr
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCaptureSession()
        self.setupDevice()
        self.setupInput()
        
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
        })
        
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.videoPreviewLayer?.frame = self.cameraView.bounds
        
        self.cameraView.layer.insertSublayer(self.videoPreviewLayer!, at: 0)
        
        self.segmentedControl.segments = LabelSegment.segments(withTitles: ["Dia 18", "Dia 19", "Dia 20"], numberOfLines: 3, normalBackgroundColor: segmentedControl.backgroundColor, normalFont: .systemFont(ofSize: 17), normalTextColor: .white, selectedBackgroundColor: segmentedControl.indicatorViewBackgroundColor, selectedFont: .boldSystemFont(ofSize: 17), selectedTextColor: .white)
        
        let presenteImage = #imageLiteral(resourceName: "checkmark.rectangle.fill").withRenderingMode(.alwaysTemplate)
        self.stateButton.setImage(presenteImage, for: .normal)
        self.stateButton.tintColor = #colorLiteral(red: 0.3831424117, green: 0.7302771807, blue: 0.2767491341, alpha: 1)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
    }
    
    @IBAction func segmentedControlAction(_ sender: BetterSegmentedControl) {
        
        UIView.animate(withDuration: 0.4) { self.personView.alpha = 0 }
        
        self.nameLabel.text = ""
        self.emailLabel.text = ""
        self.cpfLabel.text = ""
        
        if sender.index == 0 { self.day = 18 }
        else if sender.index == 1 { self.day = 19 }
        else { self.day = 20 }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        captureSession.stopRunning()
    }
    
    @IBAction func startSessionButtonAction() {
        
        UIView.animate(withDuration: 0.4) { self.personView.alpha = 0 }
        
        self.nameLabel.text = ""
        self.emailLabel.text = ""
        self.cpfLabel.text = ""
        
        UIView.animate(withDuration: 0.4) { self.stopCameraView.alpha = 0 }
        
        captureSession.startRunning()
    }
    
    func setupCaptureSession() { captureSession.sessionPreset = AVCaptureSession.Preset.high }
    
    func setupDevice() {
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            
            if device.position == AVCaptureDevice.Position.back { backCamera = device }
            else if device.position == AVCaptureDevice.Position.front { frontCamera = device }
        }
        
        currentDevice = backCamera
    }
    
    func setupInput() {
        
        do {
            
            self.captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(self.captureDeviceInput!)
            
            self.captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(self.captureMetadataOutput!)
            
            self.captureMetadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.captureMetadataOutput?.metadataObjectTypes = supportedCodeTypes
        }
            
        catch {
            
            print(error)
            return
        }
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            
            qrCodeFrameView?.frame = CGRect.zero
            
            UIView.animate(withDuration: 0.4) { self.personView.alpha = 0 }
            
            self.nameLabel.text = ""
            self.emailLabel.text = ""
            self.cpfLabel.text = ""
            
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                self.captureSession.stopRunning()
                
                DispatchQueue.main.async {
                    
                    let persons = PersonsDatabase.query().fetch() as? [PersonsDatabase] ?? []
                    let personsCPF = persons.filter({ $0.CPF == "\(metadataObj.stringValue!.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: ""))" })
                    self.person = personsCPF.filter({ $0.dia == "\(self.day)" }).first
                    
                    self.dayLabel.text = self.person?.dia
                    self.person?.frequencia = "Presente"
                    self.person?.commit()
                    
                    self.nameLabel.text = self.person?.nomeCompleto
                    self.emailLabel.text = self.person?.email
                    self.cpfLabel.text = InputTextMask.applyMask(.CPF, toText: self.person?.CPF ?? "")
                    
                    if self.person != nil {
                        
                        UIView.animate(withDuration: 0.4) { self.stopCameraView.alpha = 1 }
                        UIView.animate(withDuration: 0.4) { self.personView.alpha = 1 }
                    }
                    
                    else {
                        
                        let alert = UIAlertController(title: "Pessoa Não Encontrada", message: "O cpf contido no QRCode não corresponde a uma pessoa listada no evento", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                            
                            self.captureSession.startRunning()
                        }
                        
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
