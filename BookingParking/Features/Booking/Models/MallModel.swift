////
////  MallModel.swift
////  C4_JasJus
////
////  Created by Patricia Putri Gautama on 06/07/26.
////
//
//import Foundation
//
//struct Mall: Identifiable, Hashable, Codable {
//    let id : UUID
//    let name: String
//    let address: String
//    let distance: String
//    let pricePerHour: Int
//    let rating: Double
//    let reviewCount: Int
//    let imageName: String // asset name, fallback to system image if missing
//}
//
//extension Mall {
//    static let sample = Mall(
//        id: UUID(),
//        name: "AEON Mall BSD City",
//        address: "BSD Grand Boulevard Rd, Pagedangan, BSD City, Tangerang Selatan 15339",
//        distance: "500m",
//        pricePerHour: 5000,
//        rating: 4.8,
//        reviewCount: 120,
//        imageName: "aeon_mall"
//    )
//
//    static let recentList: [Mall] = [
//        Mall(id: UUID(), name: "AEON Mall BSD City", address: "BSD Grand Boulevard Rd, Pagedangan, BSD City, Tangerang Selatan 15339", distance: "500m", pricePerHour: 5000, rating: 4.8, reviewCount: 120, imageName: "aeon_mall"),
//        Mall(id: UUID(), name: "AEON Mall BSD City", address: "BSD Grand Boulevard Rd, Pagedangan, BSD City, Tangerang Selatan 15339", distance: "500m", pricePerHour: 5000, rating: 4.8, reviewCount: 120, imageName: "aeon_mall")
//        ]
//}
