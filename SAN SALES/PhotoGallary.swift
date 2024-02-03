//
//  PhotoGallary.swift
//  SAN SALES
//
//  Created by Anbu SaneForce on 23/05/22.
//

import Foundation
import UIKit

class PhotoGallary: IViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var imgBtnCam: UIImageView!
    @IBOutlet weak var clvwPhotoList: UICollectionView!
    @IBOutlet weak var btnBack: UIImageView!
    
    public var SFCode: String = ""
    override func viewDidLoad() {
        
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(takePhoto), userInfo: nil, repeats: false)
        clvwPhotoList.delegate = self
        clvwPhotoList.dataSource = self
        clvwPhotoList.collectionViewLayout = FlowLayout() //createLeftAlignedLayout()
        imgBtnCam.addTarget(target: self, action: #selector(takePhoto))
        btnBack.addTarget(target: self, action: #selector(GotoHome))
        /*DispatchQueue.global(qos: .userInitiated).async {
            autoreleasepool{
                self.takePhoto()
            }
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotosCollection.shared.PhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            autoreleasepool {
        let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
                let item: [String: Any]=PhotosCollection.shared.PhotoList[indexPath.row] as! [String : Any]
        cell.vwContent.layer.cornerRadius = 10
        cell.vwContent.clipsToBounds = true
        cell.vwContent.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 251/255, alpha: 1)
        cell.imgProduct.image = item["Image"] as? UIImage
                cell.vwBtnDel.addTarget(target: self, action: #selector(self.deletePhoto(_:)))
        //cell.vwBtnDel.addTarget(target: self, action: #selector(self.delJWK(_:)))
            
        return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        autoreleasepool{
        let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        
    }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("sholuld Clear Memory")
    }
    @objc private func deletePhoto(_ sender: UITapGestureRecognizer){
        let cell:CollectionCell = GlobalFunc.getCollectionViewCell(view: sender.view!) as! CollectionCell
        let tbView: UICollectionView = GlobalFunc.getCollectionView(view: sender.view!)
        let indx:NSIndexPath = tbView.indexPath(for: cell)! as NSIndexPath
        PhotosCollection.shared.PhotoList.remove(at: indx.row)
        self.clvwPhotoList.reloadData()
    }
    @objc private func takePhoto() {
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "CameraVwCtrl") as!  CameraService
        vc.modalPresentationStyle = .overCurrentContext
        vc.callback = { (photo,fileName) -> Void in
            print("callback")
            let item: [String: Any] = [
                "Image" : photo,
                "FileName":fileName
            ]
            print(item)
            PhotosCollection.shared.PhotoList.append(item as AnyObject)
            ImageUploader().uploadImage(SFCode: self.SFCode, image: photo, fileName: fileName)
            self.clvwPhotoList.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func submitPhotos() {
        self.dismiss(animated: true, completion: nil)
        //GlobalFunc.movetoHomePage()
    }
    @objc private func GotoHome() {
        self.dismiss(animated: true, completion: nil)
        //GlobalFunc.movetoHomePage()
    }
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
      let item = NSCollectionLayoutItem(          // this is your cell
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .estimated(128),         // variable width
          heightDimension: .absolute(128)          // fixed height
        )
      )
      
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
          heightDimension: .estimated(50)         // variable height; allows for multiple rows of items
        ),
        subitems: [item]
      )
      group.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
      group.interItemSpacing = .fixed(10)         // horizontal spacing between cells
        
      return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
}



