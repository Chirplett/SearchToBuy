//
//  MainViewController.swift
//  SearchToBuy
//
//  Created by Jude Song on 7/27/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [.foregroundColor: UIColor.lightGray])
        searchBar.searchBarStyle = .default
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureLayout()

       
    }
    


}

extension MainViewController: ViewDesignProtocol {
    
    func configureHierarchy() {
        view.addSubview(searchBar)
    }
    
    func configureView() {
        navigationItem.title = "영캠러의 쇼핑쇼핑"
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(44)
        }
    }
    
    
    
    
}
