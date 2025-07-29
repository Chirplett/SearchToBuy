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
    
    lazy var collectionView: UICollectionView = {
        
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
    
    var list: SearchResultOuter?
    var innerList: [SearchResultInner] = []
    var start = 1
    var isEnd = false
    var totalCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureView()
        configureLayout()
        
        callRequest()
        
    }
    
    
    func callRequest() {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(typedText)&start=\(start)&display=30"
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
                    self.collectionView.reloadData()
                    self.totalCount = value.total
                    
                case .failure(let error):
                    print("fail", error)
                }
                
                
            }
        
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
        view.addSubview(collectionView)
        
        
    }
    
    func configureView() {
        view.backgroundColor = .white
        navigationItem.title = typedText
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingButtonsStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        isEnd = totalCount <= innerList.count
        
        if indexPath.item == innerList.count - 4, isEnd == false {
            start += 30
            
            callRequest()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(innerList.count)
        return innerList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EachResultCollectionViewCell.identifier, for: indexPath) as! EachResultCollectionViewCell
        
        let eachResult = innerList[indexPath.item]
        
        cell.configureData(eachResult: eachResult)
        
        return cell
    }
    
}


extension String {
    var removingHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

    
    
