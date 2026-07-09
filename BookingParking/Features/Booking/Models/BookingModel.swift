import Foundation

struct Booking: Identifiable, Hashable {
    let id = UUID()
    var mall: MallLocation
    var date: String
    var timeRange: String
    var slot: String
    var vehicle: Vehicle
    var voucher: String?
    var paymentMethod: String?
    var pricePerHour: Int
    var duration: String
    var total: Int
    var transactionNumber: String = Booking.generateTransactionNumber()
    
    static func generateTransactionNumber() -> String {
        let dateString = DateFormatter.transactionID.string(from: .now)
        let randomSuffix = Int.random(in: 100000...9999999)
        return "TRX\(dateString)\(randomSuffix)"
    }
}

extension Int {
    var formattedRupiah: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

private extension DateFormatter {
    static let transactionID: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    } ()
}
