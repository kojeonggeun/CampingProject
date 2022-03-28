//
//  BSImagePicker.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/25.
//

import Foundation
import BSImagePicker
import UIKit
import Photos

class ImagePickerManager: ImagePickerController {

    var userSelectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    var imageFileName = [String]()
    var total: Int = 0
    var permission: Bool = false
    
    func checkAlbumPermission(){
           PHPhotoLibrary.requestAuthorization( { status in
               switch status{
               case .authorized:
                   self.permission = true
               case .denied:
                   self.permission = false
               case .restricted, .notDetermined:
                   print("Album: 선택하지 않음")
               default:
                   break
               }
           })
       }
    
    func showMultipleImagePicker(viewC: UIViewController, collection: UICollectionView, countLabel: UILabel) {
        if self.photoArray.count >= 5 {
            imageErrorAlert(viewC: viewC)
            return
        }
        
        
        self.settings.selection.max = 5
        self.settings.selection.unselectOnReachingMax = true
        self.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        self.albumButton.tintColor = UIColor.green
        self.cancelButton.tintColor = UIColor.red

        self.settings.theme.selectionFillColor = UIColor.blue
        self.settings.theme.selectionStrokeColor = UIColor.white
        self.settings.theme.selectionShadowColor = UIColor.white
        self.settings.theme.previewTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]
        self.settings.theme.previewSubtitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white]
        self.settings.theme.albumTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]

        var tempAssets = [PHAsset]()

        viewC.presentImagePicker(self, select: { (asset) in

            tempAssets.append(asset)

            if self.userSelectedAssets.count + tempAssets.count > 5 {
                self.imageErrorAlert(viewC: self)
                self.deselect(asset: asset)

                tempAssets.remove(at: tempAssets.endIndex - 1)
            }

        }, deselect: { (asset) in
            if let firstIndex = tempAssets.firstIndex(where: { $0 == asset }) {
                tempAssets.remove(at: firstIndex)
            } else {
                return
            }
        }, cancel: { (_) in
            // User canceled selection.
        }, finish: { (assets) in

            for asset in assets {
                self.userSelectedAssets.append(asset)
            }
            self.convertAssetToImages(collectionV: collection)

            countLabel.text = "(\(self.photoArray.count) / 5"
        })
    }
    func imageErrorAlert(viewC: UIViewController) {

        let alert = UIAlertController(title: nil, message: "이미지는 5장까지 등록 가능합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        viewC.present(alert, animated: true)

    }

    func convertAssetToImages(collectionV: UICollectionView) {
            for num in total..<userSelectedAssets.count {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()

                let asset = PHAssetResource.assetResources(for: userSelectedAssets[num])

                var thumbnail = UIImage()
                option.deliveryMode = .opportunistic
                option.isSynchronous = true
                
                manager.requestImage(for: userSelectedAssets[num], targetSize: CGSize(width: 500, height: 300), contentMode: .aspectFill, options: option, resultHandler: {(result, _) -> Void in
                    thumbnail = result!
                })

                self.photoArray.append(thumbnail)
                self.imageFileName.append(asset.first!.originalFilename)
                collectionV.reloadData()
            }
            self.total = userSelectedAssets.count
    }
}
