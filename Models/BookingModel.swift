//
//  Booking.swift
//  C4_JasJus
//
//  Created by Patricia Putri Gautama on 06/07/26.
//

import Foundation

struct Booking: Identifiable, Hashable {
    let id = UUID()
    var mall: Mall
    var date: String
    var timeRange: String
    var slot: String
    var vehicle: Vehicle?
    var voucher: String?
    var paymentMethod: String?
    var tariffPerHour: Int
    var duration: String
    var total: Int
}
