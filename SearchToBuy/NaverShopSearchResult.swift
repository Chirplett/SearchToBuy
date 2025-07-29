//
//  NaverShopSearchResult.swift
//  SearchToBuy
//
//  Created by Jude Song on 7/28/25.
//

import Foundation

struct SearchResultOuter: Decodable {
    let total: Int
    let display: Int
    let items: [SearchResultInner]
}

struct SearchResultInner: Decodable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
}
