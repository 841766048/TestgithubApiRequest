//
//  UIImageView+Category.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import UIKit
import Kingfisher
import Toucan
import QuartzCore

public typealias ZYCompletionHandler =
    ((_ image: KFCrossPlatformImage?, _ error: NSError? , _ imageURL: URL?) -> Void)

//MARK: Kingfisher
extension UIImageView {
    func zy_setImage(urlString: String?, placeholder:UIImage?) {
        var imageUrl: URL?
        if let imageString = urlString {
            imageUrl = URL(string: imageString)
        } else {
            imageUrl = nil
        }
        self.kf.setImage(with: imageUrl, placeholder: placeholder)
    }
    
    func zy_setImage(urlString: String?, placeholder:UIImage?, options: KingfisherOptionsInfo? = nil, progressBlock: DownloadProgressBlock? = nil,
                     completionHandler: ZYCompletionHandler? = nil) {
        var imageUrl: URL?
        if let imageString = urlString {
            imageUrl = URL(string: imageString)
        } else {
            imageUrl = nil
        }
        self.kf.setImage(with: imageUrl, placeholder: placeholder, options: options, progressBlock: { (receivedSize, totalSize) in
            progressBlock?(receivedSize,totalSize)
        }, completionHandler: { (result) in
            switch result {
            case let .success(value):
                completionHandler?(value.image, nil, imageUrl)
            case let .failure(error):
                completionHandler?(nil, error as NSError, imageUrl)
            }
        })

    }
}
extension UIImageView {
    
    /**
     Loads an image from a URL. If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.
     
     - Parameter url: The image URL.
     - Parameter placeholder: The placeholder image.
     - Parameter fadeIn: Weather the mage should fade in.
     - Parameter closure: Returns the image from the web the first time is fetched.
     
     - Returns A new image
     */
    func imageFromURL(_ url: String, placeholder: UIImage, fadeIn: Bool = true, shouldCacheImage: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil)
    {
        self.image = UIImage.image(fromURL: url, placeholder: placeholder, shouldCacheImage: shouldCacheImage) {
            (image: UIImage?) in
            if image == nil {
                return
            }
            self.image = image
            if fadeIn {
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = CATransitionType.fade
                self.layer.add(transition, forKey: nil)
            }
            closure?(image)
        }
    }
    
    
}
 

extension UIImageView {
    func zy_setImage(urlString: String?, placeholder:UIImage?, corner:CGFloat, borderColor:UIColor?, borderWidth: CGFloat, size: CGSize) {
        let imageCache = ImageCache.default

        if let imageString = urlString {
            var isTransform = false

            /// 1. 拼接裁剪后的图片的key
            var transformImageKey = imageString
            var transformPlaceholderKey = ""
            if placeholder != nil {
                transformPlaceholderKey += (placeholder?.description)!
            }
            if corner > 0 {
                let cornerString = String.init(format:"%.2f", corner)
                transformImageKey += cornerString
                transformPlaceholderKey += cornerString
                isTransform = true
            }
            if borderColor != nil {
                transformImageKey += (borderColor?.description)!
                let borderWidthStr = String.init(format:"%.2f", borderWidth)
                transformImageKey += borderWidthStr
                transformPlaceholderKey += (borderColor?.description)!
                isTransform = true
            }
            
            /// 2. 从缓存中查找裁剪后的图片
            if isTransform {
                let transformCacheImage = imageCache.retrieveImageInMemoryCache(forKey: transformImageKey)
                if transformCacheImage != nil {
                    self.image = transformCacheImage
                    return
                }
            }
            
            /// 3. 缓存中没有, 加载图片
            /// 3.1 裁剪占位图, 并缓存
            var placeholderImage: UIImage? = nil
            if placeholder != nil {
                if isTransform {
                    placeholderImage = imageCache.retrieveImageInMemoryCache(forKey: transformPlaceholderKey)
                }
                if placeholderImage == nil {
                    if borderColor != nil {
                        placeholderImage = Toucan(image: placeholder!).resize( CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale), fitMode: .scale).maskWithRoundedRect(cornerRadius: corner * UIScreen.main.scale, borderWidth: borderWidth  * UIScreen.main.scale, borderColor: borderColor!).image
                    } else {
                        if corner > 0 {
                            placeholderImage = Toucan(image: placeholder!).resize( CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale), fitMode: .scale).maskWithRoundedRect(cornerRadius: corner * UIScreen.main.scale).image
                        }
                    }
                    if isTransform && placeholderImage != nil {
                        imageCache.store(placeholderImage!, forKey: transformPlaceholderKey)
                    }
                }
            }
            
            /// 3.2 加载网络图片, 裁剪并缓存
            self.zy_setImage(urlString: urlString, placeholder: placeholderImage, options: nil, progressBlock: nil) { (image, error, url) in
                var newImage: UIImage? = nil
                if image != nil {
                    if borderColor != nil {
                        newImage = Toucan(image: image!).resize( CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale), fitMode: .scale).maskWithRoundedRect(cornerRadius: corner * UIScreen.main.scale, borderWidth: borderWidth * UIScreen.main.scale, borderColor: borderColor!).image
                    } else {
                        if corner > 0 {
                            newImage = Toucan(image: image!).resize( CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale), fitMode: .scale).maskWithRoundedRect(cornerRadius: corner * UIScreen.main.scale).image
                        }
                    }
                }
                if newImage != nil {
                    imageCache.store(newImage!, forKey: transformImageKey)
                    self.image = newImage
                } else {
                    self.image = image
                }
            }
        } else {
            /// 显示占位图
            if placeholder != nil {
                var image = placeholder
                if borderColor != nil {
                    image = Toucan(image: placeholder!).resize( CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale), fitMode: .scale).maskWithRoundedRect(cornerRadius: corner * UIScreen.main.scale, borderWidth: borderWidth  * UIScreen.main.scale, borderColor: borderColor!).image
                } else {
                    if corner > 0 {
                        image = Toucan(image: placeholder!).resize( CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale), fitMode: .scale).maskWithRoundedRect(cornerRadius: corner * UIScreen.main.scale).image
                    }
                }
                self.image = image
            }
        }
    }
}


