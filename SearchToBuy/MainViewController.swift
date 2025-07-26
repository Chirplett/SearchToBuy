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
    
    private let defaultLabel: UILabel = {
        let defaultLabel = UILabel()
        defaultLabel.text = "쇼핑을 시작해 보세요!"
        defaultLabel.font = .systemFont(ofSize: 16, weight: .medium)
        defaultLabel.textAlignment = .center
        return defaultLabel
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
        view.addSubview(defaultLabel)
    }
    
    func configureView() {
        navigationItem.title = "영캠러의 쇼핑쇼핑"
        searchBar.delegate = self
        navigationItem.backButtonTitle = ""
        
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(44)
        }
        defaultLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let typedText = searchBar.text, typedText.count >= 2 else {
            return
        }
        
        let viewController = SearchResultViewController()
        navigationController?.pushViewController(viewController, animated: true)
        
        viewController.typedText = typedText
        
    }
    
    
}
