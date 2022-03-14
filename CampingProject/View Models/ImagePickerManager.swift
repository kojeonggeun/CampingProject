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

    func showMultipleImagePicker(viewC: UIViewController, collection: UICollectionView, countLabel: UILabel) {
        if self.photoArray.count >= 5 {
            imageErrorAlert(viewC: viewC)
            return
        }

        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.selection.unselectOnReachingMax = true
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.albumButton.tintColor = UIColor.green
        imagePicker.cancelButton.tintColor = UIColor.red

        imagePicker.settings.theme.selectionFillColor = UIColor.blue
        imagePicker.settings.theme.selectionStrokeColor = UIColor.white
        imagePicker.settings.theme.selectionShadowColor = UIColor.white
        imagePicker.settings.theme.previewTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]
        imagePicker.settings.theme.previewSubtitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white]
        imagePicker.settings.theme.albumTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]

        var tempAssets = [PHAsset]()

        viewC.presentImagePicker(imagePicker, select: { (asset) in

            tempAssets.append(asset)

            if self.userSelectedAssets.count + tempAssets.count > 5 {
                self.imageErrorAlert(viewC: imagePicker)
                imagePicker.deselect(asset: asset)

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
                manager.requestImage(for: userSelectedAssets[num], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, _) -> Void in
                    thumbnail = result!
                })

                self.photoArray.append(thumbnail)
                self.imageFileName.append(asset.first!.originalFilename)

                collectionV.reloadData()
            }
            self.total = userSelectedAssets.count
    }
}
