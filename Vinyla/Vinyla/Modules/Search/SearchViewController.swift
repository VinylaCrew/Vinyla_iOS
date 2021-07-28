//
//  SearchViewController.swift
//  Vinyla
//
//  Created by IJ . on 2021/07/25.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var vinylSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        setUI()
        setTableViewCellXib()
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
