//
//  ViewController.swift
//  ImageCollection
//
//  Created by Meet's MAC on 30/08/22.
//

import UIKit
import Photos
import AVKit
import InteractiveSideMenu

class ViewController: UIViewController, SideMenuItemContent, Storyboardable {

//    @IBOutlet weak var col_images: UICollectionView!
//    var photoLibraryImages = [UIImage]()
//    var photoLibraryAssets = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()

//        getPhotosFromAlbum()
    }

    // Show side menu on menu button click
    @IBAction func openMenu(_ sender: UIButton) {
        showSideMenu()
    }

//    func getPhotosFromAlbum()
//    {
//
//        //                    let finalPhotos = albumName.photoAlbum
//        DispatchQueue.global(qos: .userInteractive).async
//        {
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
//
//            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
//            let customAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
//
//            [smartAlbums, customAlbums].forEach {
//                $0.enumerateObjects { collection, index, stop in
//
//                    let imgManager = PHImageManager.default()
//
//                    let requestOptions = PHImageRequestOptions()
//                    requestOptions.isSynchronous = true
//                    requestOptions.deliveryMode = .highQualityFormat
//
//                    //                            let photoInAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)
//                    let photoInAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)
//                    print("TITLE : \(collection.localizedTitle)")
//                    if let title = collection.localizedTitle
//                    {
//                        if photoInAlbum.count > 0
//                        {
//                            print("\n\n \(title) --- count = \(photoInAlbum.count) \n\n")
//
//                            //MARK: - Play video
////                            photoInAlbum.firstObject?.getURL(completionHandler: { responseURL in
////
////                                DispatchQueue.main.async {
////                                    print(responseURL)
////                                    let player = AVPlayer(url: responseURL!)
////                                    let playerViewController = AVPlayerViewController()
////                                    playerViewController.player = player
////                                    self .present(playerViewController, animated: true) {
////                                        playerViewController.player!.play()
////                                    }
////                                }
////                            })
//
//                            //MARK: - Delete images
////                            PHPhotoLibrary.shared().performChanges( {
////                                PHAssetChangeRequest.deleteAssets([photoInAlbum.firstObject!] as NSArray)
////                            },
////                                                                    completionHandler: { success, error in
////                                print("Success : \(success)")
////                                print("Error : \(error)")
////                            })
//
//                        }
//                    }
//                }
//            }
//        }
//    }

    //MARK: - Play video
    func playVideo(view:UIViewController, asset:PHAsset) {

        guard (asset.mediaType == .video) else {
            print("Not a valid video media type")
            return
        }

        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (asset, audioMix, args) in
            let asset = asset as! AVURLAsset

            DispatchQueue.main.async {
                let player = AVPlayer(url: asset.url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                view.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
    }
}
//
//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//
//    func collectionSetup(){
//        col_images.delegate = self
//        col_images.dataSource = self
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photoLibraryImages.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = col_images.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
//        cell.img_image.image = photoLibraryImages[indexPath.row]
//        return cell
//    }
//}



extension PHAsset {

    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}

extension PHAsset {
    var originalFilename: String? {
        var fileName: String?

        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fileName = resource.originalFilename
            }
        }

        if fileName == nil {
            /// This is an undocumented workaround that works as of iOS 9.1
            fileName = self.value(forKey: "filename") as? String
        }

        return fileName
    }
}
