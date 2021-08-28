//
//  SearchViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/25.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet weak var vinylSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    var disposeBag = DisposeBag()
    
    private weak var coordiNator: AppCoordinator?
    private var viewModel: SearchViewModel?

    var vinylSongName: String?
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
        vinylSearchBar.searchTextField.delegate = self
        setUI()
        setTableViewCellXib() //rxcocoa도 그대로 사용
        bindTableView()
        didSelectCell()
        setInputSongTitleRx()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vinylSearchBar.searchTextField.becomeFirstResponder()
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
    
    func setTableViewCellXib() {
        let searchNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(searchNib, forCellReuseIdentifier: "searchTableViewCell")
    }
    
    @IBAction func touchUpViewPopButton(_ sender: UIButton) {
        coordiNator?.popViewController()
    }
    func setInputSongTitleRx() {
        guard let viewModel = self.viewModel else {
            return
        }
        vinylSearchBar.rx.text
            .orEmpty
            .distinctUntilChanged() // 중복 데이터 스트림 반복 X
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map{
                print($0)
                return $0
            }
            .bind(to: viewModel.orderNumber)
            .disposed(by: disposeBag)

        viewModel.isSearch
            .subscribe(onNext: { [weak self] item in
                print(item)
                if item == false {
                    self?.view.endEditing(true)
                }
            })
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
        guard let viewModel = self.viewModel else {
            print("vm error")
            return
        }

        viewModel.moviesData
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn([])
            .bind(to: searchTableView.rx.items) { tableView, index, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell") as? SearchTableViewCell else { return UITableViewCell()}
                cell.songTitleLabel.text = element?.title
                cell.singerNameLabel.text = element?.id
                let url = URL(string: (element?.thumb)!)
                do {
                    let data = try Data(contentsOf: url!)
                    cell.searchVinylImageView.image = UIImage(data: data)
                }
                catch {
                    print(error.localizedDescription)
                }
                return cell
            }.disposed(by: disposeBag)
        
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
        searchTableView.rx.modelSelected(MovieModel.Data.self)
            .subscribe(onNext: { [weak self] model in
                print(model.title)
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
