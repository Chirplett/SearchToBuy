//
//  PromotionCollectionViewCell.swift
//  SearchToBuy
//
//  Created by Jude Song on 7/30/25.
//

import UIKit

class PromotionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PromotionCollectionViewCell"
    
    private let promotionImageView: UIImageView = {
        let promotionImageView = UIImageView()
        promotionImageView.contentMode = .scaleAspectFill
        promotionImageView.backgroundColor = .green
        return promotionImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy(){
        contentView.addSubview(promotionImageView)
        
    }
    func configureLayout(){
        promotionImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    func configureView(){}
    
}
