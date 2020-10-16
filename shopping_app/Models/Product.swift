//
//  Product.swift
//  shopping_app
//
//  Created by Evghenia Moroz on 10/15/20.
//

import Foundation

struct Products: Decodable {
    var products: [Product]
    var currentPage, pageSize, totalResults, pageCount: Int
}

struct Product: Decodable {
    let productID: Int
    let productName: String
    let reviewInformation: ReviewInformation
    let usPS: [String]
    let availabilityState: Int
    let salesPriceIncVat: Double
    let productImage: String
    let coolbluesChoiceInformationTitle: String?
    let promoIcon: PromoIcon?
    let nextDayDelivery: Bool
    let listPriceIncVat: Int?
    let listPriceExVat: Double?
    
    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case productName, reviewInformation
        case usPS = "USPs"
        case availabilityState, salesPriceIncVat, productImage, coolbluesChoiceInformationTitle, promoIcon, nextDayDelivery, listPriceIncVat, listPriceExVat
    }
}

struct PromoIcon: Decodable {
    let text: String
    let type: TypeEnum
}

enum TypeEnum: String, Decodable {
    case actionPrice = "action-price"
    case coolbluesChoice = "coolblues-choice"
    case image = "image"
}

struct ReviewInformation: Decodable {
    //    let reviews: []
    let reviewSummary: ReviewSummary
}

struct ReviewSummary: Decodable {
    let reviewAverage: Double
    let reviewCount: Int
}
