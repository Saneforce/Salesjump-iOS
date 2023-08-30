//
//  CameraService.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 22/03/22.
//
import UIKit
import Foundation
import AVFoundation
extension AVCaptureDevice {
    enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
        case unknown
    }

    class func authorizeVideo(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.video, completion: completion)
    }

    class func authorizeAudio(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.audio, completion: completion)
    }

    private class func authorize(mediaType: AVMediaType, completion: ((AuthorizationStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        if status == .authorized {
            completion?(.alreadyAuthorized)
        }else{
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                        DispatchQueue.main.async {
                            if granted {
                                completion?(.justAuthorized)
                            } else {
                                Toast.show(message: "Please Enable Camera Permission.") //, controller: UIViewController
                            
                            }
                        }
                    })
                }
           
        }
    }
}
class CameraService: IViewController , AVCapturePhotoCaptureDelegate{
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var previewLayer = AVCaptureVideoPreviewLayer()
    var output = AVCapturePhotoOutput()
    var callback: ((_ photo: UIImage, _ fileName: String) -> Void)?
    
   // AVCapturePhotoCaptureDelegate?
    @IBOutlet weak var CamPrevHolder: UIView!
    @IBOutlet weak var imgCamImage: UIImageView!
    @IBOutlet weak var btnTakePic: UIButton!
    @IBOutlet weak var btOk: UIButton!
    @IBOutlet weak var btRetry: UIButton!
    
    var SFCode: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCaptureSession()
        
        let LocalStoreage = UserDefaults.standard
        let prettyPrintedJson=LocalStoreage.string(forKey: "UserDetails")
        let data = Data(prettyPrintedJson!.utf8)
        
        guard let prettyJsonData = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
        else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        SFCode = prettyJsonData["sfCode"] as? String ?? ""
        
        
        btnTakePic.layer.cornerRadius = 35
        btnTakePic.layer.borderWidth = 1.0
        btnTakePic.layer.borderColor = UIColor.init(red: 239.0/255, green: 243.0/255, blue: 251.0/255, alpha: 0.67).cgColor
        
        btOk.layer.cornerRadius = 15
        btOk.layer.borderWidth = 1.0
        btOk.layer.borderColor = UIColor.init(red: 239.0/255, green: 243.0/255, blue: 251.0/255, alpha: 0.67).cgColor
        
        btRetry.layer.cornerRadius = 15
        btRetry.layer.borderWidth = 1.0
        btRetry.layer.borderColor = UIColor.init(red: 239.0/255, green: 243.0/255, blue: 251.0/255, alpha: 0.67).cgColor
        btOk.isHidden = true
        btRetry.isHidden = true
        imgCamImage.isHidden=true
        
        
    }
    
    func initializeCaptureSession(){
        session.sessionPreset = AVCaptureSession.Preset.high
        camera = AVCaptureDevice.default(for: AVMediaType.video)
        
        
        if camera != nil {
            do{
                
                let cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
                output = AVCapturePhotoOutput()
                session.addInput(cameraCaptureInput)
                session.addOutput(output)
                
            }catch{
                print(error.localizedDescription)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                previewLayer.frame = CamPrevHolder.bounds
            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
            CamPrevHolder.layer.insertSublayer(previewLayer, at: 0)
            if session.isRunning == false {
                DispatchQueue.global().async {
                    self.session.startRunning()
                }
            }
        }
    }
    
    @IBAction func takePicture(_ sender: Any) {
        autoreleasepool{
            AVCaptureDevice.authorizeVideo(completion: { (status) in
                if(status != .alreadyAuthorized){
                    return
                }
                self.takePicture()
            })
    
        }
        
    }
    @IBAction func retryPic(_ sender: Any) {
        
        CamPrevHolder.isHidden = false
        btOk.isHidden = true
        btRetry.isHidden = true
        btnTakePic.isHidden=false
        imgCamImage.isHidden=true
    }
    
    @IBAction func CloseCtrler(_ sender: Any) {
        CamPrevHolder.isHidden = true
        btOk.isHidden = false
        btRetry.isHidden = false
        btnTakePic.isHidden=true
        imgCamImage.isHidden=false
        dismiss(animated: true)
    }
    @IBAction func savePic(_ sender: Any) {
        autoreleasepool{
            let photo: UIImage = imgCamImage.image!
            print(photo)
            CamPrevHolder.isHidden = true
            btOk.isHidden = false
            btRetry.isHidden = false
            btnTakePic.isHidden=true
            imgCamImage.isHidden=false
           // let fileName: String = String(format: "Img%@_%i.jpg", SFCode,Int(Date().timeIntervalSince1970))
            let fileName: String = String(Int(Date().timeIntervalSince1970))
            let filenameno="\(SFCode)__\(fileName).jpg"
            print(filenameno)
            
            callback?(photo,filenameno)
            dismiss(animated: true)
        }
    }
    
    func takePicture(){
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        output.capturePhoto(with: settings, delegate: self)
    }
    func displayCapturedPhoto(capturedPhoto: UIImage){
        imgCamImage.image = capturedPhoto
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        autoreleasepool{
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            }else{
                if let sampleBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                    if let finalImage = UIImage(data: dataImage){
                        displayCapturedPhoto(capturedPhoto: finalImage)
                        CamPrevHolder.isHidden = true
                        
                        imgCamImage.isHidden=false
                        btOk.isHidden = false
                        btRetry.isHidden = false
                        btnTakePic.isHidden=true
                    }
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if session.isRunning {
            DispatchQueue.global().async {
                self.session.stopRunning()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
