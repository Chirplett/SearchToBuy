//
//  SearchResultViewController.swift
//  SearchToBuy
//
//  Created by Jude Song on 7/27/25.
//

import UIKit
import SnapKit
import Alamofire

class SearchResultViewController: UIViewController {
    
    var typedText: String = ""
    var currentSort: String = "sim"
    
    private let numberOfResultLabel: UILabel = {
        let numberOfResultLabel = UILabel()
        numberOfResultLabel.textColor = .systemGreen
        numberOfResultLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        numberOfResultLabel.textAlignment = .left
        return numberOfResultLabel
    }()
    
    private let sortBySimilarityButton: UIButton = {
        let sortBySimilarityButton = UIButton()
        sortBySimilarityButton.setTitle("  정확도순  ", for: .normal)
        sortBySimilarityButton.setTitleColor(.systemGray2, for: .normal)
        sortBySimilarityButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        sortBySimilarityButton.layer.borderColor = UIColor.systemGray2.cgColor
        sortBySimilarityButton.layer.borderWidth = 1
        sortBySimilarityButton.layer.cornerRadius = 5
        return sortBySimilarityButton
    }()
    
    private let sortByDateDscButton: UIButton = {
        let sortByDateDscButton = UIButton()
        sortByDateDscButton.setTitle("  날짜순  ", for: .normal)
        sortByDateDscButton.setTitleColor(.systemGray2, for: .normal)
        sortByDateDscButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        sortByDateDscButton.layer.borderColor = UIColor.systemGray2.cgColor
        sortByDateDscButton.layer.borderWidth = 1
        sortByDateDscButton.layer.cornerRadius = 5
        return sortByDateDscButton
    }()
    
    private let sortByPriceDscButton: UIButton = {
        let sortByPriceDscButton = UIButton()
        sortByPriceDscButton.setTitle("  가격높은순  ", for: .normal)
        sortByPriceDscButton.setTitleColor(.systemGray2, for: .normal)
        sortByPriceDscButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        sortByPriceDscButton.layer.borderColor = UIColor.systemGray2.cgColor
        sortByPriceDscButton.layer.borderWidth = 1
        sortByPriceDscButton.layer.cornerRadius = 5
        return sortByPriceDscButton
    }()
    
    private let sortByPriceAscButton: UIButton = {
        let sortByPriceAscButton = UIButton()
        sortByPriceAscButton.setTitle("  가격낮은순  ", for: .normal)
        sortByPriceAscButton.setTitleColor(.systemGray2, for: .normal)
        sortByPriceAscButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        sortByPriceAscButton.layer.borderColor = UIColor.systemGray2.cgColor
        sortByPriceAscButton.layer.borderWidth = 1
        sortByPriceAscButton.layer.cornerRadius = 5
        return sortByPriceAscButton
    }()
    
    private let sortingButtonsStackView: UIStackView = {
        let sortingButtonsStackView = UIStackView()
        sortingButtonsStackView.axis = .horizontal
        sortingButtonsStackView.spacing = 8
        //        sortingButtonsStackView.alignment = .center
        sortingButtonsStackView.distribution = .fill
        return sortingButtonsStackView
    }()
    
    lazy var mainResultCollectionView: UICollectionView = { //lazy var를 써야 되는 이유?
        
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (16 * 2) - (12 * 1)
        
        //        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: cellWidth/2, height: cellWidth/2 * 1.4)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.register(EachResultCollectionViewCell.self, forCellWithReuseIdentifier: EachResultCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
        
    }()
    
    lazy var promotionCollectionView: UICollectionView = {
        view.backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        
        //        let width = UIScreen.main.bounds.width
        //        let spacing = 8.0
        //        let itemCount = 2.6
        //
        //        let dimension = (width - (spacing * 2)) / itemCount //1개의 너비
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        
        let promotionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        promotionCollectionView.register(PromotionCollectionViewCell.self, forCellWithReuseIdentifier: PromotionCollectionViewCell.identifier)
        
        promotionCollectionView.delegate = self
        promotionCollectionView.dataSource = self
        
        return promotionCollectionView
    }()
    
    private var list: SearchResultOuter?
    private var innerList: [SearchResultInner] = []
    private var promotionList : [SearchResultInner] = []
    private var start = 1
    private var isEnd = false
    private var totalCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureView()
        configureLayout()
        
        callRequest(sort: currentSort)
        
    }
    
    
    func callRequest(sort: String) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(typedText)&start=\(start)&display=30&sort=\(sort)"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverKeyID,
            "X-Naver-Client-Secret": APIKey.naverKeySecret
        ]
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchResultOuter.self) { response in
                
                switch response.result {
                case .success(let value):
                    dump(value)
                    
                    self.innerList.append(contentsOf: value.items)
                    self.numberOfResultLabel.text = "\(value.total)개의 검색 결과"
                    self.mainResultCollectionView.reloadData()
                    self.totalCount = value.total
                    
                case .failure(let error):
                    self.showAlert(title: "오류", message: "네트워크 통신에 실패하였습니다. \n잠시 후 다시 시도해주세요.")
                    print("fail", error)
                    
                }
                
                
            }
        
    }
    
    @objc private func sortingButtonsClicked(_ sender: UIButton) {
        
        if sender == sortBySimilarityButton {
            currentSort = "sim"
        } else if sender == sortByDateDscButton {
            currentSort = "date"
        } else if sender == sortByPriceDscButton {
            currentSort = "dsc"
        } else if sender == sortByPriceAscButton {
            currentSort = "asc"
        }
        
        updateSortingButtonsUI(selected: sender)
        resetSearch()
        callRequest(sort: currentSort)
    }
    
    private func updateSortingButtonsUI(selected: UIButton) {
        let allButtons = [
            sortBySimilarityButton,
            sortByDateDscButton,
            sortByPriceDscButton,
            sortByPriceAscButton
        ]
        
        for button in allButtons {
            if button == selected {
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
                button.layer.borderColor = UIColor.white.cgColor
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.systemGray2, for: .normal)
                button.layer.borderColor = UIColor.systemGray2.cgColor
            }
        }
    }
    
    private func resetSearch() {
        start = 1
        isEnd = false
        innerList.removeAll()
        mainResultCollectionView.reloadData()
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
        
    }
}



extension SearchResultViewController: ViewDesignProtocol {
    
    func configureHierarchy() {
        view.addSubview(numberOfResultLabel)
        
        sortingButtonsStackView.addArrangedSubview(sortBySimilarityButton)
        sortingButtonsStackView.addArrangedSubview(sortByDateDscButton)
        sortingButtonsStackView.addArrangedSubview(sortByPriceDscButton)
        sortingButtonsStackView.addArrangedSubview(sortByPriceAscButton)
        
        view.addSubview(sortingButtonsStackView)
        view.addSubview(mainResultCollectionView)
        
        view.addSubview(promotionCollectionView)
        
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = typedText
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        sortBySimilarityButton.addTarget(self, action: #selector(sortingButtonsClicked(_:)), for: .touchUpInside)
        sortByDateDscButton.addTarget(self, action: #selector(sortingButtonsClicked(_:)), for: .touchUpInside)
        sortByPriceDscButton.addTarget(self, action: #selector(sortingButtonsClicked(_:)), for: .touchUpInside)
        sortByPriceAscButton.addTarget(self, action: #selector(sortingButtonsClicked(_:)), for: .touchUpInside)
    }
    
    func configureLayout() {
        numberOfResultLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        sortingButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(numberOfResultLabel.snp.bottom).offset(8)
            make.leading.equalTo(numberOfResultLabel.snp.leading)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        mainResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingButtonsStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            //            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        promotionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainResultCollectionView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        isEnd = totalCount <= innerList.count
        
        if indexPath.item == innerList.count - 4, isEnd == false {
            start += 30
            
            callRequest(sort: currentSort)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainResultCollectionView {
            return innerList.count
        } else {
            return 10
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainResultCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EachResultCollectionViewCell.identifier, for: indexPath) as? EachResultCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            let eachResult = innerList[indexPath.item]
            
            cell.configureData(eachResult: eachResult)
            
            return cell
            
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCollectionViewCell.identifier, for: indexPath) as? PromotionCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            return cell
        }
    }
    

}

extension String { //왜 익스텐션에서는 저장 프로퍼티를 못 쓸까?
    var removingHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
