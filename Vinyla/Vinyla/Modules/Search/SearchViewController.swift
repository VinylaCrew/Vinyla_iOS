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
    let disposeBag = DisposeBag()
    
    private weak var coordiNator: AppCoordinator?
    private weak var viewModel: SearchViewModel?
    
    static func instantiate(viewModel: SearchViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "Search") as? SearchViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchTableView.dataSource = self
        
        setUI()
        setTableViewCellXib() //rxcocoa도 그대로 사용
        bindTableView()
        didSelectCell()
    }
    
    func setUI() {
        //search bar color custom
        vinylSearchBar.searchTextField.textColor = UIColor.white
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
    
    func bindTableView() {
        let cities = Observable.of(["Lisbon", "Copenhagen", "London", "Madrid", "Vienna", "Seoul"])
        cities.observe(on: MainScheduler.instance)
            .bind(to: searchTableView.rx.items) { (tableView: UITableView, index: Int, element: String) in
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell") as? SearchTableViewCell else { return UITableViewCell()}
                        
            cell.songTitleLabel.text = element
            
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    func didSelectCell() {
        searchTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] model in
                print("seletecd \(model)")
                self?.coordiNator?.songNameCD = "\(model)"
                self?.coordiNator?.moveToAddReview()
            })
            .disposed(by: disposeBag)
        
        searchTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("selected \(indexPath)")
            })
            .disposed(by: disposeBag)
        
        
    }
    
}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchTableViewCell") as? SearchTableViewCell else { return UITableViewCell()}
        
        return cell
    }
    
    
}
