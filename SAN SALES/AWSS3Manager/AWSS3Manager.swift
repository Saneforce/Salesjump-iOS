//
//  AWSS3Manager.swift
//  SAN SALES
//
//  Created by Mani V on 27/09/24.
//


import Foundation
import UIKit
import AWSS3
import AVFoundation
import MobileCoreServices

typealias progressBlock = (_ progress: Double) -> Void
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void

class AWSS3Manager {
    
    static let shared = AWSS3Manager()
    private init () { }
   // let bucketName = "happic"
    let bucketName = "salesjump"
    
    func uploadImage(FileName:String,image: UIImage, progress: progressBlock?, completion: completionBlock?) {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return
        }
        
        let tmpPath = NSTemporaryDirectory() as String
       // let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpg")
        let fileName: String = FileName
        let filePath = tmpPath + "/" + fileName
        let fileUrl = URL(fileURLWithPath: filePath)
        
        print(filePath)
        print(fileUrl)
        
        do {
            try imageData.write(to: fileUrl)
            self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: "image", progress: progress, completion: completion)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
        }
    }
    
    func uploadVideo(videoUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        compressVideo(videoURL: videoUrl) { [weak self] compressedVideoURL in
            guard self != nil else { return }
            
            guard let compressedURL = compressedVideoURL else {
                print("Video compression failed.")
                return
            }

            print("Compressed video URL: \(compressedURL)")
            let fileName = self?.getUniqueFileName(fileUrl: compressedURL)
            let mimeType = self?.getMimeType(for: compressedURL) // Fetch correct MIME type
            self?.uploadfile(fileUrl: compressedURL, fileName: fileName ?? "", contenType: mimeType ?? "", progress: progress, completion: completion)
    }
    }
    
    func compressVideo(videoURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: videoURL)

        guard AVAssetExportSession.exportPresets(compatibleWith: asset).contains(AVAssetExportPresetMediumQuality) else {
            print("Preset not supported.")
            completion(nil)
            return
        }
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            completion(nil)
            return
        }
        
        let compressedVideoURL = generateTempURL()

        exportSession.outputURL = compressedVideoURL
        exportSession.outputFileType = .mp4
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(compressedVideoURL)
            case .failed:
                print("Export failed: \(String(describing: exportSession.error))")
                completion(nil)
            case .cancelled:
                print("Export cancelled")
                completion(nil)
            default:
                break
            }
        }
    }

    func generateTempURL() -> URL {
        let tempDirectory = NSTemporaryDirectory()
        let fileName = UUID().uuidString + ".mp4"
        let tempURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(fileName)
        return tempURL
    }
    
    func uploadAudio(audioUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: audioUrl)
        self.uploadfile(fileUrl: audioUrl, fileName: fileName, contenType: "audio", progress: progress, completion: completion)
    }
    func uploadOtherFile(fileUrl: URL, conentType: String, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: fileUrl)
        let mimeType = getMimeType(for: fileUrl)
        print(mimeType)
        self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: mimeType, progress: progress, completion: completion)
    }

    func getUniqueFileName(fileUrl: URL) -> String {
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
    }
    
    func getMimeType(for fileUrl: URL) -> String {
        let pathExtension = fileUrl.pathExtension.lowercased()

        switch pathExtension {
        case "jpeg", "jpg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "mp4":
            return "video/mp4"
        case "mov":
            return "video/quicktime"
        case "mp3":
            return "audio/mpeg"
        case "mp3":
            return "audio/mpeg"
        case "wav":
            return "audio/wav"
        case "zip":
            return "application/zip"
        case "pdf":
            return "application/pdf"
        default:
            return "application/octet-stream"
        }
    }

    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        
        // MARK: - upload dynamic path
        //var path = "iosuploadsMani/images"
        let path =  UserSetup.shared.Logo_Name
        let fullFileName = (path.isEmpty ? "" : "\(path)/") + fileName
        
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(fileName)
                    print("Uploaded to:\(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, nil)
                    }
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fullFileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("error is: \(error.localizedDescription)")
            }
            if let result = task.result {
                print(result)
            }
            return nil
        }
    }
}
