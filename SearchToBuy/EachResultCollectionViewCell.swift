//
//  EachResultCollectionViewCell.swift
//  SearchToBuy
//
//  Created by Jude Song on 7/29/25.
//

import UIKit
import SnapKit
import Kingfisher

class EachResultCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EachResultCollectionViewCell"
    
    let thumbnailImageView = UIImageView()
    let mallNameLabel =  UILabel()
    let titleLabel = UILabel()
    let lowestPriceLabel = UILabel()
    let likeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lowestPriceLabel)
        contentView.addSubview(likeButton)
    }
    
    func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(thumbnailImageView.snp.width)
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        lowestPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.greaterThanOrEqualToSuperview().inset(8)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(thumbnailImageView.snp.trailing).inset(16)
            make.bottom.equalTo(thumbnailImageView.snp.bottom).inset(16)
            make.leading.greaterThanOrEqualTo(thumbnailImageView.snp.leading).offset(16)
            make.top.greaterThanOrEqualTo(thumbnailImageView.snp.top).offset(16)
        }
        
    }
    
    func configureView() {
        thumbnailImageView.contentMode = .scaleAspectFill
//        thumbnailImageView.backgroundColor = .yellow
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.clipsToBounds = true
        
        mallNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        mallNameLabel.textColor = .systemGray
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .systemGray
        titleLabel.numberOfLines = 2
        
        lowestPriceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        lowestPriceLabel.textColor = .systemGray
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.backgroundColor = .white
        likeButton.layer.backgroundColor = UIColor.white.cgColor
        
    }
    
    func configureData(eachResult: SearchResultInner) {
        
        let url = URL(string: eachResult.image)
        thumbnailImageView.kf.setImage(with: url)
        
        mallNameLabel.text = eachResult.mallName
        
        titleLabel.text = eachResult.title.removingHTMLTags
        
        lowestPriceLabel.text = eachResult.lprice

        
    }
    
}
