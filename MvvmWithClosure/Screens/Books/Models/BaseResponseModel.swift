//
//  BaseResponseModel.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import Foundation

// MARK: - Welcome
struct BaseResponseModel: Codable {
    let kind: String?
    let totalItems: Int?
    let items: [BookModel]?
}

// MARK: - Item
struct BookModel: Codable {
    let kind: String?
    let id: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let accessInfo: AccessInfo?
    let searchInfo: SearchInfo?
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publishedDate: String?
    let pageCount: Int?
    let printType: String?
    let language: String?
    let previewLink: String?
    let infoLink: String?
    let publisher: String?
    let imageLinks: ImageLinks?
    let categories: [String]?
    let subtitle: String?
    let description: String?
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let country: String?
    let saleability: String?
    let isEbook: Bool?
    let listPrice, retailPrice: SaleInfoListPrice?
    let buyLink: String?
    let offers: [Offer]?
}

// MARK: - AccessInfo
struct AccessInfo: Codable {
    let country: String?
    let viewability: String?
    let embeddable, publicDomain: Bool?
    let epub, pdf: Epub?
    let webReaderLink: String?
    let accessViewStatus: String?
    let quoteSharingAllowed: Bool?
}

// MARK: - Epub
struct Epub: Codable {
    let isAvailable: Bool?
    let acsTokenLink: String?
}

// MARK: - SaleInfoListPrice
struct SaleInfoListPrice: Codable {
    let amount: Double?
    let currencyCode: String?
}

// MARK: - Offer
struct Offer: Codable {
    let finskyOfferType: Int?
    let listPrice, retailPrice: OfferListPrice?
}

// MARK: - OfferListPrice
struct OfferListPrice: Codable {
    let amountInMicros: Int?
    let currencyCode: String?
}

// MARK: - SearchInfo
struct SearchInfo: Codable {
    let textSnippet: String?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail, medium, large, extraLarge: String?
}
