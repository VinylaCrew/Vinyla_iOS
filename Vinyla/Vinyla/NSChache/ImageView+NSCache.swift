//
//  ImageView+NSCache.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/30.
//

import UIKit

extension UIImageView {
    func setImageChache(imageURL: String) {
        if let cachedImage = NSCacheManager.shared.object(forKey: imageURL as NSString) {
            self.image = cachedImage
            return
        }

        //동기적 cahcing 방법
        DispatchQueue.global(qos: .background).async {
            guard let insideImageURL = URL(string: imageURL), let imageData = try? Data(contentsOf: insideImageURL), let willBeCachedImage = UIImage(data: imageData) else {
                print("image cahcing background thread error")
                return
            }
            //백그라운드 스레드로 image data를 얻어오고 메인 스레드에서 캐싱작업과 이미지뷰에 이미지를 넣어주는 작업 진행
            //백그라운드 스레드 지정을 위해 qos background로 지정 - 기기 효율 에너지와 연관
            DispatchQueue.main.async {
                NSCacheManager.shared.setObject(willBeCachedImage, forKey: imageURL as NSString)
                self.image = willBeCachedImage
            }
        }
    }

    func setImageURLAndChaching(_ imageURL: String?) {

        guard let imageURL = imageURL else { return }

        DispatchQueue.global(qos: .default).async {

            /// cache할 객체의 key값을 string으로 생성
            let cachedKey = NSString(string: imageURL)

            /// cache된 이미지가 존재하면 그 이미지를 사용 (API 호출안하는 형태)
            if let cachedImage = NSCacheManager.shared.object(forKey: cachedKey) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
                return
            }

//            DispatchQueue.main.async {
//                if let cachedImage = NSCacheManager.shared.object(forKey: cachedKey) {
//                        self.image = cachedImage
//                    return
//                }
//            }

            guard let url = URL(string: imageURL) else { return }

            let dataTask = URLSession.shared.dataTask(with: url) { (data, result, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage()
                    }
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {

                        /// 캐싱
                        NSCacheManager.shared.setObject(image, forKey: cachedKey)
                        self?.image = image
                    }
                }
            }
                dataTask.resume()

        }
    }

}
