//
//  AWSS3_Download_Manager.swift
//  SAN SALES
//
//  Created by Mani V on 27/09/24.
//

import UIKit
import AWSS3
import AVKit
import PDFKit
import AVFoundation

/*class S3Manager{
    func listFilesInS3Bucket(bucketName: String, completion: @escaping ([String]?, Error?) -> Void) {
            let s3 = AWSS3.default()
            let listObjectsRequest = AWSS3ListObjectsRequest()!
            listObjectsRequest.bucket = bucketName
            
            s3.listObjects(listObjectsRequest).continueWith { task -> AnyObject? in
                if let error = task.error {
                    print("Error occurred: \(error.localizedDescription)")
                    completion(nil, error)
                    return nil
                }
                
                var fileKeys = [String]()
                
                if let result = task.result {
                    for object in result.contents! {
                        if let key = object.key {
                            fileKeys.append(key)
                        }
                    }
                }
                
                completion(fileKeys, nil)
                return nil
            }
        }
    
    
    func downloadFileFromS3(bucketName: String, fileKey: String, completion: @escaping (Data?, Error?) -> Void) {
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.downloadData(
            fromBucket: bucketName,
            key: fileKey,
            expression: nil
        ) { (task, url, data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            } else if let data = data {
                print("Downloaded Data: \(data.count) bytes")
                completion(data, nil)
            }
        }
    }
    
    func downloadSpecificFileFromS3(bucketName: String, fileKey: String, completion: @escaping (Data?, Error?) -> Void) {
          let transferUtility = AWSS3TransferUtility.default()

          transferUtility.downloadData(
              fromBucket: bucketName,
              key: fileKey,
              expression: nil
          ) { (task, url, data, error) in
              if let error = error {
                  print("Error downloading file: \(error.localizedDescription)")
                  completion(nil, error)
              } else if let data = data {
                  print("Successfully downloaded file \(fileKey) with size \(data.count) bytes")
                  completion(data, nil)
              }
          }
      }
}*/

@objc protocol Closeable {
    @objc func closeButtonTapped()
}


class S3FileManager {

    static let shared = S3FileManager()
    var player: AVAudioPlayer?
    private init() {}

    // Function to download a specific file from S3
    func downloadFileFromS3(bucketName: String, fileKey: String, completion: @escaping (Data?, String?, Error?) -> Void) {
        let transferUtility = AWSS3TransferUtility.default()

        transferUtility.downloadData(
            fromBucket: bucketName,
            key: fileKey,
            expression: nil
        ) { (task, url, data, error) in
            if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
                completion(nil, nil, error)
            } else if let data = data {
                let fileExtension = (fileKey as NSString).pathExtension.lowercased()
                completion(data, fileExtension, nil)
            }
        }
    }

    // Function to handle the downloaded file based on its type
    func handleDownloadedFile(fileExtension: String, data: Data, viewController: UIViewController) {
        switch fileExtension {
        case "jpg", "jpeg", "png", "gif":
            self.handleImage(data: data, viewController: viewController)
        case "mp4", "mov", "m4v":
            self.playVideoFromData(data: data, viewController: viewController)
        case "mp3", "wav", "m4a":
            self.playAudioFromData(data: data)
        case "pdf":
            self.displayPDF(data: data, viewController: viewController)
        default:
            print("Unsupported file type: \(fileExtension)")
        }
    }

    // MARK: - Private Helper Methods for Different File Types

    private func handleImage(data: Data, viewController: UIViewController) {
        DispatchQueue.main.async {
            if let image = UIImage(data: data) {
                let imageView = UIImageView(frame: viewController.view.bounds)
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                viewController.view.addSubview(imageView)

                // Add close button
                self.addCloseButton(to: viewController)
                print("Image displayed with close button")
            } else {
                print("Failed to display image")
            }
        }
    }

    private func playVideoFromData(data: Data, viewController: UIViewController) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempVideo.mp4")
        do {
            try data.write(to: tempURL)
            let player = AVPlayer(url: tempURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

            // Add close button to the player's view controller
            DispatchQueue.main.async {
                self.addCloseButton(to: playerViewController)
            }

            viewController.present(playerViewController, animated: true) {
                player.play()
            }
        } catch {
            print("Error saving or playing video: \(error.localizedDescription)")
        }
    }

    private func playAudioFromData(data: Data) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempAudio.mp3")
        print(tempURL)
        let url = tempURL

            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
    }

    private func displayPDF(data: Data, viewController: UIViewController) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempFile.pdf")
        do {
            try data.write(to: tempURL)

            let pdfView = PDFView(frame: viewController.view.bounds)
            pdfView.autoScales = true
            pdfView.document = PDFDocument(url: tempURL)
            viewController.view.addSubview(pdfView)

            // Add close button
            self.addCloseButton(to: viewController)
            print("PDF displayed with close button")
        } catch {
            print("Error displaying PDF: \(error.localizedDescription)")
        }
    }

    // MARK: - Adding Close Button

    private func addCloseButton(to viewController: UIViewController) {
        // Check if viewController conforms to Closeable protocol
        guard let closeableVC = viewController as? Closeable else {
            print("ViewController does not conform to Closeable")
            return
        }

        let closeButton = UIButton(frame: CGRect(x: 20, y: 50, width: 80, height: 40))
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .red
        closeButton.layer.cornerRadius = 10
        closeButton.addTarget(closeableVC, action: #selector(closeableVC.closeButtonTapped), for: .touchUpInside)

        viewController.view.addSubview(closeButton)
    }
}

