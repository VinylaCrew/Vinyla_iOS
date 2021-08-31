//
//  ImageView+NSCache.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/30.
//

import UIKit

extension UIImageView {
    func setImageChache(imageURL: String) {
        if let cachedImage = NSCacheManager.shaerd.object(forKey: imageURL as NSString) {
            self.image = cachedImage
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let insideImageURL = URL(string: imageURL), let imageData = try? Data(contentsOf: insideImageURL), let willBeCachedImage = UIImage(data: imageData) else {
                print("image cahcing background thread error")
                return
            }
            //백그라운드 스레드로 image data를 얻어오고 메인 스레드에서 캐싱작업과 이미지뷰에 이미지를 넣어주는 작업 진행
            //백그라운드 스레드 지정을 위해 qos background로 지정 - 기기 효율 에너지와 연관
            DispatchQueue.main.async {
                NSCacheManager.shaerd.setObject(willBeCachedImage, forKey: imageURL as NSString)
                self.image = willBeCachedImage
            }
        }
    }
}
