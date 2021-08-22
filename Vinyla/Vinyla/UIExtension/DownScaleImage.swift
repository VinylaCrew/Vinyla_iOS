//
//  DownScaleImage.swift
//  Vinyla
//
//  Created by IJ . on 2021/08/07.
//

import UIKit

extension UIImage {
//    func downScaleImage(imageData: Data, for size: CGSize, scale:CGFloat) -> UIImage {
//            // dataBuffer가 즉각적으로 decoding되는 것을 막아줍니다.
//            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else { return UIImage() }
//            let maxDimensionInPixels = max(size.width, size.height) * scale
//            let downsampleOptions =
//                [kCGImageSourceCreateThumbnailFromImageAlways: true,
//                 kCGImageSourceShouldCacheImmediately: true, //  thumbNail을 만들 때 decoding이 일어나도록 합니다.
//                 kCGImageSourceCreateThumbnailWithTransform: true,
//                 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
//            
//            // 위 옵션을 바탕으로 다운샘플링 된 `thumbnail`을 만듭니다.
//            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return UIImage() }
//            return UIImage(cgImage: downsampledImage)
//    }
}
