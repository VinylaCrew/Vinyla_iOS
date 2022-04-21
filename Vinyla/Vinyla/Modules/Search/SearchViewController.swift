//
//  SearchViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {

    lazy var lookingforVinylButton: UIButton = {
        let button = UIButton()

        // Define the size of the button
        let width: CGFloat = self.view.bounds.width-195
        let height: CGFloat = 48

        // Define coordinates to be placed.
        // (center of screen)
        let posX: CGFloat = 15
        let posY: CGFloat = self.view.bounds.height-28-48
        print("viewboundsheight")
        print(self.view.bounds.height)

        // Set the button installation coordinates and size.
        button.frame = CGRect(x: posX, y: posY, width: width, height: height)

        // Set the background color of the button.
        button.backgroundColor = UIColor.buttonOrangeColor()

        // Round the button frame.
        button.layer.masksToBounds = true

        // Set the radius of the corner.
        button.layer.cornerRadius = 24.0
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 15)
        button.titleLabel?.textAlignment = .center
        // Set the title (normal).
        button.setTitle("찾는 바이닐 요청하기", for: .normal)
        button.setTitleColor(.white, for: .normal)

        // Set the title (highlighted).
        button.setTitle("찾는 바이닐 요청하기", for: .highlighted)
        button.setTitleColor(.black, for: .highlighted)

        // Tag a button.
        button.tag = 1

        // Add an event
//        button.addTarget(self, action: #selector(touchUpSaveBoxButton(_:)), for: .touchUpInside)

        return button
    }()

    @IBOutlet weak var vinylSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var noSearchInformationView: UIView!
    @IBOutlet weak var vinylCountLabel: UILabel!
    @IBOutlet weak var userSearchTextLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    var lookingForVinylButtonBottomAnchor: NSLayoutConstraint?

    var disposeBag = DisposeBag()

    private weak var coordiNator: AppCoordinator?
    private var viewModel: SearchViewModelType?

    static func instantiate(viewModel: SearchViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "Search") as? SearchViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noSearchInformationView.isHidden = true
        setLookingForVinylButtonUI()
        lookingforVinylButton.rx.tap
            .subscribe({ [weak self] _ in
                //요청뷰 이동
                self?.coordiNator?.presentRequestUserVinylView()
            })
            .disposed(by: disposeBag)
        vinylSearchBar.searchTextField.delegate = self
        setUI()
        setTableViewCellXib() //rxcocoa도 그대로 사용
        bindCountLabel()
        bindTableView()
        didSelectCell()
        setInputSongTitleRx()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if vinylSearchBar.text?.isEmpty == true {
            vinylSearchBar.searchTextField.becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func setUI() {
        //search bar color custom
        vinylSearchBar.searchBarStyle = .minimal
        vinylSearchBar.searchTextField.textColor = UIColor.white
        vinylSearchBar.layer.cornerRadius = 8
        vinylSearchBar.clipsToBounds = true
        vinylSearchBar.barTintColor = .clear
        vinylSearchBar.searchTextField.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 26/255, alpha: 1)
        vinylSearchBar.searchTextField.layer.borderWidth = 1
        vinylSearchBar.searchTextField.layer.borderColor = CGColor(red: 40/255, green: 40/255, blue: 41/255, alpha: 1)
        vinylSearchBar.searchTextField.layer.cornerRadius = 8
        if let leftView = vinylSearchBar.searchTextField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor.white
        }
        if let rightView = vinylSearchBar.searchTextField.rightView as? UIImageView {
            //            rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
            rightView.tintColor = UIColor.white
        }
        //https://fomaios.tistory.com/entry/%EC%84%9C%EC%B9%98%EB%B0%94-%EC%BB%A4%EC%8A%A4%ED%85%80%ED%95%98%EA%B8%B0-Custom-UISearchBar
    }
    func setLookingForVinylButtonUI() {
        self.view.addSubview(lookingforVinylButton)
        lookingforVinylButton.translatesAutoresizingMaskIntoConstraints = false
        lookingforVinylButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        lookingforVinylButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28).isActive = true
        lookingForVinylButtonBottomAnchor = lookingforVinylButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28)
        lookingForVinylButtonBottomAnchor?.isActive = true
        lookingforVinylButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width-195).isActive = true
        lookingforVinylButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func setTableViewCellXib() {
        let searchNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(searchNib, forCellReuseIdentifier: "searchTableViewCell")
    }
    
    @IBAction func touchUpViewPopButton(_ sender: UIButton) {
        coordiNator?.popNoAnimationViewController()
    }
    func setInputSongTitleRx() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        vinylSearchBar.rx.text
            .orEmpty
            .distinctUntilChanged() // 중복 데이터 스트림 반복 X
            .debounce(.milliseconds(550), scheduler: MainScheduler.instance)
            .skip(1)
            .bind(to: viewModel.vinylName)
            .disposed(by: disposeBag)

        //        viewModel.isSearch
        //            .subscribe(onNext: { [weak self] item in
        //                print(item)
        //                if item == false {
        //                    self?.view.endEditing(true)
        //                }
        //            })
    }
    func bindCountLabel() {
        guard let viewModel = self.viewModel else {
            print("ViewModel error")
            return
        }
        viewModel.vinylsCount
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn("0")
            .map{ item in
                return item! + "개의 검색결과가 있습니다."
            }
            .bind(to: vinylCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    func bindTableView() {
        //        let cities = Observable.of(["Lisbon", "Copenhagen", "London", "Madrid", "Vienna", "Seoul"])
        //        cities.observeOn(MainScheduler.instance)
        //            .bind(to: searchTableView.rx.items) { (tableView: UITableView, index: Int, element: String) in
        //
        //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell") as? SearchTableViewCell else { return UITableViewCell()}
        //
        //            cell.songTitleLabel.text = element
        //
        //            return cell
        //        }.disposed(by: disposeBag)

        self.searchTableView.rx.setDelegate(self).disposed(by: disposeBag)

        guard let viewModel = self.viewModel else {
            print("ViewModel Init Error")
            return
        }

        viewModel.vinylsData
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn([])
            .map{ $0!}
//            .do(onNext: { data in
//                print("do do:",data)
//                if data.isEmpty {
//                    print("빈 배열",data)
//                }
//            })
//            .map{ data -> [SearchModel2.Data] in
//                if let data = data {
//                    return data
//                }else {
//                    return []
//                }
//            }
            .bind(to: searchTableView.rx.items) { tableView, index, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell") as? SearchTableViewCell else { return UITableViewCell()}
                cell.songTitleLabel.text = element.title
                cell.singerNameLabel.text = element.artist
                if let imageURLString = element.thumb {
                    cell.setCachedImage(imageURL: imageURLString)
                }
                return cell
            }.disposed(by: disposeBag)

        viewModel.vinylsData
            .map{ $0?.count ?? 0 < 1 }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isEmpty in
                //MARK: - TODO 찾는 바이닐 없는 경우, UI 처리
                guard let self = self else { return }
                if isEmpty {
                    do {
                        guard let userSearchText = try self.viewModel?.userSearchText.value() else { return }
                        if userSearchText == "" {
                            self.noSearchInformationView.isHidden = true
                            self.lookingForVinylButtonBottomAnchor?.constant = -28
                            return
                        }
                        let attributedString = NSMutableAttributedString(string: "\(userSearchText)에 대한 검색 결과가 DB에 없어요.")
                        let font = UIFont(name: "NotoSansKR-Medium", size: 15)
                        attributedString.addAttribute(.font, value: font, range: (userSearchText as NSString).range(of:"\(userSearchText)에 대한 검색 결과가 DB에 없어요."))
                        attributedString.addAttribute(.foregroundColor, value: UIColor.vinylaMainOrangeColor(), range: (userSearchText as NSString).range(of:"\(userSearchText)"))
                        self.userSearchTextLabel.attributedText = attributedString
                        self.noSearchInformationView.isHidden = false

                    } catch {
                        print(error)
                    }
                    if self.lookingForVinylButtonBottomAnchor?.constant == -28 {
                        //MARK: Todo 버튼 높낮이 계산
                        if UIScreen.main.bounds.height >= 812 {
                            self.lookingForVinylButtonBottomAnchor?.constant -= floor((UIScreen.main.bounds.height / 3 )) + 35
                        }else {
                            self.lookingForVinylButtonBottomAnchor?.constant -= floor((UIScreen.main.bounds.height / 4 )) + 20
                        }
                    }
                }else {
                    self.lookingForVinylButtonBottomAnchor?.constant = -28
                    self.noSearchInformationView.isHidden = true
                }
            })
            .disposed(by: disposeBag)

    }
    
    func didSelectCell() {
        //        searchTableView.rx.modelSelected(String.self)
        //            .subscribe(onNext: { [weak self] model in
        //                print("seletecd \(model)")
        //                self?.coordiNator?.songNameCD = "\(model)"
        //                self?.vinylSongName = "\(model)"
        //                guard let songTitle = self?.vinylSongName else {
        //                    return
        //                }
        //                self?.coordiNator?.moveToAddInformationView(vinylDataModel: songTitle)
        //                print("pushAddInformationView")
        //            })
        //            .disposed(by: disposeBag)
        searchTableView.rx.modelSelected(SearchModel.Data.self)
            .subscribe(onNext: { [weak self] model in
                self?.coordiNator?.moveToAddInformationView(vinylID: model.id, vinylImageURL: model.thumb, isDeleteMode: false)
            })
            .disposed(by: disposeBag)
        
        searchTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("selected \(indexPath)")

            })
            .disposed(by: disposeBag)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.vinylSearchBar.searchTextField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SearchTableViewCell else { return }
        //        print("did end display",cell.testURL)
        //        print("did end display",cell.cellImageDataTask)
        //        print("did end display",indexPath.row)
        //        cell.cellImageDataTask?.cancel()
        
//        cell.searchVinylImageView.kf.cancelDownloadTask()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(107)
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lookingforVinylButton.alpha = 0.4
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lookingforVinylButton.alpha = 1.0
    }
}
