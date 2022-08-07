//
//  SearchTableViewCell.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/29.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchVinylImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var customSeperatorView: UIView!

    var cellImageDataTask: URLSessionDataTask?
    var testURL: String?

    lazy var whiteCircleVinylView: UIView = { () -> UIView in
        let view = UIView()

        let width: CGFloat = 23
        let height: CGFloat = 23
        let positionX: CGFloat = 0
        let positionY: CGFloat = 0
        view.frame = CGRect(x: positionX, y: positionY, width: width, height: height)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5

        let blackCircleView = UIView()
        blackCircleView.frame = CGRect(x: 0, y: 0, width: 3, height: 3)
        blackCircleView.backgroundColor = .black
        blackCircleView.layer.masksToBounds = true
        blackCircleView.layer.cornerRadius = blackCircleView.frame.height/2
        view.addSubview(blackCircleView)

        let blackCircleViewHorizontal = blackCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let blackCircleViewVertical = blackCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let blackCircleViewWidth = blackCircleView.widthAnchor.constraint(equalToConstant: 3)
        let blackCircleViewHeight = blackCircleView.heightAnchor.constraint(equalToConstant: 3)
        blackCircleView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([blackCircleViewHorizontal, blackCircleViewVertical, blackCircleViewWidth, blackCircleViewHeight])

        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        searchVinylImageView.layer.cornerRadius = searchVinylImageView.frame.height/2
        searchVinylImageView.addSubview(whiteCircleVinylView)
        setAutoLayoutWhiteCircleView()
        customSeperatorView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.cellImageDataTask?.cancel()
        self.searchVinylImageView.image = nil

//        self.searchVinylImageView.kf.cancelDownloadTask()
    }

    func setCachedImage(imageURL: String) {
        self.testURL = imageURL
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in

            /// cache할 객체의 key값을 string으로 생성
            let cachedKey = NSString(string: imageURL)

            /// cache된 이미지가 존재하면 그 이미지를 사용 (API 호출안하는 형태)
            if let cachedImage = NSCacheManager.shared.object(forKey: cachedKey) {
                DispatchQueue.main.async {
                    self?.searchVinylImageView.image = cachedImage
                }
                return
            }


            guard let url = URL(string: imageURL) else { return }

            self?.cellImageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, result, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.searchVinylImageView.image = UIImage()
                    }
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {

                        /// 캐싱
                        NSCacheManager.shared.setObject(image, forKey: cachedKey)
                        self?.searchVinylImageView.image = image
                    }
                }
            }

            self?.cellImageDataTask?.resume()

        }
    }

    func setAutoLayoutWhiteCircleView() {
        let whiteCircleVinylViewCenterX = whiteCircleVinylView.centerXAnchor.constraint(equalTo: searchVinylImageView.centerXAnchor)
        let whiteCircleVinylViewCenterY = whiteCircleVinylView.centerYAnchor.constraint(equalTo: searchVinylImageView.centerYAnchor)
        let whiteCircleVinylViewWidthConstraint = whiteCircleVinylView.widthAnchor.constraint(equalToConstant: 23)
        let whiteCircleVinylViewHeightConstraint = whiteCircleVinylView.heightAnchor.constraint(equalToConstant: 23)
        searchVinylImageView.addConstraints([whiteCircleVinylViewCenterX,whiteCircleVinylViewCenterY,whiteCircleVinylViewWidthConstraint,whiteCircleVinylViewHeightConstraint])
    }
    
}
