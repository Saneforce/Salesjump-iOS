//
//  ImageUploader.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 28/05/22.
//

import Foundation
import Alamofire
import UIKit

class ImageUploader {
    func uploadImage(SFCode: String,image: UIImage,fileName: String)
    {
        
         let imgData = image.jpegData(compressionQuality: 0.80)

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName:"imgfile", fileName:fileName, mimeType:"image/jpg")
        }, to: APIClient.shared.BaseURL+APIClient.shared.DBURL1 + "imgupload&sf_code=" + SFCode)
        .uploadProgress { progress in
            print(progress)
        }
        .responseJSON { [weak self] response in
            print(response)
        }
    }
}

class ImageUploade {
    func uploadImage(SFCode: String, image: UIImage, fileName: String, completion: @escaping () -> Void) {
        let imgData = image.jpegData(compressionQuality: 0.25)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "imgfile", fileName: fileName, mimeType: "image/jpg")
        }, to: APIClient.shared.BaseURL+APIClient.shared.DBURL1 + "imgupload&sf_code=" + SFCode)
        .uploadProgress { progress in
            print(progress)
        }
        .responseJSON { response in
            print(response)
            completion() // Call the completion handler when the response is received
        }
    }
}
