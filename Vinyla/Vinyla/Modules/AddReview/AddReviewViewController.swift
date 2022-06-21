//
//  AddReviewViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/30.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos

final class AddReviewViewController: UIViewController {
    
    //화면위 고정되는 저장 버튼
    lazy var saveVinylButton: UIButton = {
        let button = UIButton()
        
        // Define the size of the button
        let width: CGFloat = self.view.bounds.width-30
        let height: CGFloat = 62
        
        // Define coordinates to be placed.
        // (center of screen)
        let posX: CGFloat = 15
        let posY: CGFloat = self.view.bounds.height-28-62
        print("viewboundsheight")
        print(self.view.bounds.height)
        
        // Set the button installation coordinates and size.
        button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        
        // Set the background color of the button.
        button.backgroundColor = UIColor(red: 255/255, green: 63/255, blue: 0/255, alpha: 1)
        
        // Round the button frame.
        button.layer.masksToBounds = true
        
        // Set the radius of the corner.
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .center
        // Set the title (normal).
        button.setTitle("보관함에 저장하기(2/2)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        // Set the title (highlighted).
        button.setTitle("보관함에 저장하기(2/2)", for: .highlighted)
        button.setTitleColor(.black, for: .highlighted)
        
        // Tag a button.
        button.tag = 1
        
        // Add an event
        button.addTarget(self, action: #selector(touchUpSaveBoxButton(_:)), for: .touchUpInside)
        
        return button
    }()

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
        view.alpha = 0.6

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

    lazy var pointCircleView: UIView = {
    let view = UIView()
        view.frame = CGRect(x: recommendMentLabel.frame.size.width, y: 0, width: 5, height: 5)
        view.backgroundColor = UIColor.vinylaMainOrangeColor()
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    @IBOutlet weak var songTitleNameLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songRateLabel: UILabel!
    @IBOutlet weak var reviewScrollView: UIScrollView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var starCosmosView: CosmosView!
    @IBOutlet weak var starScoreLabel: UILabel!
    @IBOutlet weak var vinylImageView: UIImageView!
    @IBOutlet weak var userReviewCommentCountLabel: UILabel!
    @IBOutlet weak var recommendMentLabel: UILabel!

    private weak var coordinator: AppCoordinator?
    private var viewModel: AddReviewViewModel?

    var disposeBag = DisposeBag()
    
    static func instantiate(viewModel: AddReviewViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "AddReview", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "AddReview") as? AddReviewViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordinator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        songTitleNameLabel.text = viewModel.model.title
        songArtistLabel.text = viewModel.model.artist
        songRateLabel.text = String(round(viewModel.songRate ?? 0)) + " (\(viewModel.songRateCount ?? 0)건)"
        vinylImageView.setImageURLAndChaching((viewModel.thumbnailImage ?? ""))

        reviewTextView.rx.text
            .orEmpty
            .bind(to: viewModel.userCommnet)
            .disposed(by: disposeBag)

        print("vinyl detail model:",self.viewModel?.model)

        self.view.addSubview(saveVinylButton)
        vinylImageView.addSubview(whiteCircleVinylView)
        recommendMentLabel.addSubview(pointCircleView)
        setAutoLayoutWhiteCircleView()
        reviewScrollView.delegate = self
        setStarUI()
        setCountTextViewInLabel()
        setPlaceholderTextView()
        limitReviewTextCount()
        setKeyboardDoneItem()
        setKeyboardDisapperResetOriginalFrame()
        frameControlDidBeginEditing()
        setupBindError()
    }

    func setStarUI() {
        starCosmosView.settings.emptyImage = UIImage(named: "icnOffStar")
        starCosmosView.settings.filledImage = UIImage(named: "icnStar")
        starCosmosView.backgroundColor = .black
        starCosmosView.settings.fillMode = .half
        // Change the size of the stars
        starCosmosView.settings.starSize = 40
        // Set the distance between stars
        starCosmosView.settings.starMargin = 5
        starCosmosView.rating = 0
        starCosmosView.settings.minTouchRating = 0
        starCosmosView.didFinishTouchingCosmos = { [weak self] rating in
            self?.starScoreLabel.text = "\(Int(rating*2.0))"
            self?.viewModel?.userRate.onNext(Int(rating*2.0))
        }
        reviewTextView.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.cornerRadius = 8
        vinylImageView.layer.cornerRadius = vinylImageView.frame.size.height/2
    }

    func setAutoLayoutWhiteCircleView() {
        let whiteCircleVinylViewCenterX = whiteCircleVinylView.centerXAnchor.constraint(equalTo: vinylImageView.centerXAnchor)
        let whiteCircleVinylViewCenterY = whiteCircleVinylView.centerYAnchor.constraint(equalTo: vinylImageView.centerYAnchor)
        let whiteCircleVinylViewWidthConstraint = whiteCircleVinylView.widthAnchor.constraint(equalToConstant: 23)
        let whiteCircleVinylViewHeightConstraint = whiteCircleVinylView.heightAnchor.constraint(equalToConstant: 23)
        vinylImageView.addConstraints([whiteCircleVinylViewCenterX,whiteCircleVinylViewCenterY,whiteCircleVinylViewWidthConstraint,whiteCircleVinylViewHeightConstraint])
    }

    func setKeyboardDoneItem() {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let buttonDoneBar = UIBarButtonItem(title: "작성 완료", style: .done, target: self, action: #selector(self.doneBtnClicked))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [flexSpace, buttonDoneBar]
        toolBarKeyboard.tintColor = UIColor.vinylaMainOrangeColor()
        reviewTextView.inputAccessoryView = toolBarKeyboard
    }

    func setKeyboardDisapperResetOriginalFrame() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func doneBtnClicked (sender: Any) {
        self.view.endEditing(true)
    }

    func setCountTextViewInLabel() {
        reviewTextView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.userReviewCommentCountLabel.text = String(text.count)
            })
            .disposed(by: disposeBag)
    }

    func limitReviewTextCount() {
        reviewTextView.rx.text.orEmpty
            .map{ $0.count <= 150 }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext:{ [weak self] isEditable in
                if !isEditable {
                    self?.reviewTextView.text = String(self?.reviewTextView.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
    }

    func setPlaceholderTextView() {
        reviewTextView.rx.didBeginEditing
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if(self.reviewTextView.text == "이 음반에 대해 감상평을 솔직하게 남겨주세요." ) {
                    self.reviewTextView.text = nil
                    self.reviewTextView.textColor = .white
                }}).disposed(by: disposeBag)

        reviewTextView.rx.didEndEditing
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
                if self.reviewTextView.text == nil || self.reviewTextView.text == "" {
                    self.reviewTextView.text = "이 음반에 대해 감상평을 솔직하게 남겨주세요."
                    self.reviewTextView.textColor = UIColor.textColor()
                    self.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
    }

    func frameControlDidBeginEditing() {
        reviewTextView.rx.didBeginEditing
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= (self.reviewTextView.frame.height + 15)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupBindError() {
        self.viewModel?.apiError
            .subscribe(onNext:{ [weak self] error in
                if error == NetworkError.requestDataError {
                    self?.coordinator?.setupToast(message: "   필수항목(추천지수)을 입력해 주세요.   ", title: nil)
                }
                
                if error == NetworkError.alreadyExistedVinylError {
                    self?.coordinator?.setupToast(message: "   이미 저장된 바이닐입니다.   ", title: nil)
                }
                
            })
            .disposed(by: disposeBag)
    }

    @IBAction func touchUpBackButton(_ sender: Any) {
        coordinator?.popViewController()
    }
    
    @IBAction func touchUpSaveBoxButton(_ sender: Any) {

//        guard let insideImageURL = URL(string: (viewModel?.model.image)!), let imageData = try? Data(contentsOf: insideImageURL), let vinylImage = UIImage(data: imageData) else {
//            print("vinyl image error")
//            return
//        }
        
        guard let tthumnailVinylImageData = vinylImageView.image?.jpegData(compressionQuality: 1) else {
            self.coordinator?.setupToast(message: "   바이닐 저장 실패, 다시 시도해 주세요.   ", title: nil)
            return
        }

        let chekedCompletedispatchGroup = DispatchGroup()
        chekedCompletedispatchGroup.enter()
        viewModel?.requestSaveVinylData(tthumbailVinylImageData: tthumnailVinylImageData, reviewVCDispatchGroup: chekedCompletedispatchGroup)
        chekedCompletedispatchGroup.notify(queue: .main){ [weak self] in
            if CoreDataManager.shared.isSavedSpecificVinyl {
                self?.coordinator?.popToVinylBoxView()
                self?.coordinator?.setupToast(message: "   바이닐이 저장되었습니다.   ", title: nil)
            } else {
                self?.coordinator?.setupToast(message: "   바이닐 저장 실패, 다시 시도해 주세요.   ", title: nil)
            }
        }
        
    }
}

extension AddReviewViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.saveVinylButton.alpha = 0.4
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.saveVinylButton.alpha = 1.0
    }
}
