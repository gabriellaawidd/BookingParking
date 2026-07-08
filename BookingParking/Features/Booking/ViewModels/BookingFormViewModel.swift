
import Foundation

@Observable
class BookingFormViewModel {
    let mall: MallLocation
    let pricePerHour: Int

    var vehicles: [Vehicle] = Vehicle.registered
    var selectedVehicle: Vehicle?

    var selectedSlot: String?
    var selectedVoucher: String?
    var startTime: Date?
    var endTime: Date?
    var bookingDate: Date?

    var isSubmitting = false
    var errorMessage: String?

    init(mall: MallLocation, pricePerHour: Int = 5000) {
        self.mall = mall
        self.pricePerHour = pricePerHour
    }
    
    var hasBooked: Bool {
        if selectedSlot != nil && selectedVehicle != nil {
            return true
        }
        return false
    }

    var isFormValid: Bool {
        selectedVehicle != nil && selectedSlot != nil
    }

    var durationHours: Int {
        guard let startTime, let endTime else { return 1 }
        let minutes = Calendar.current.dateComponents([.minute], from: startTime, to: endTime).minute ?? 0
        return max(Int(ceil(Double(minutes) / 60.0)), 1)
    }

    var total: Int {
        pricePerHour * durationHours
    }

    var durationLabel: String {
        guard let startTime, let endTime else { return "" }
        let components = Calendar.current.dateComponents([.hour, .minute], from: startTime, to: endTime)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        return minutes == 0 ? "\(hours) hours" : "\(hours)h \(minutes)m"
    }

    var timeRangeLabel: String {
        guard let startTime, let endTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }

    var dateLabel: String {
        guard let bookingDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: bookingDate)
    }

    var dayRangeLabel: String {
        guard let bookingDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: bookingDate)
    }

    func applySlotSelection(slotID: String, date: Date, start: Date, end: Date) {
        selectedSlot = slotID
        bookingDate = date
        startTime = start
        endTime = end
    }

    func addVehicle(_ vehicle: Vehicle) {
        vehicles.append(vehicle)
        selectedVehicle = vehicle
    }

    func submitBooking() async -> Booking? {
        guard isFormValid, let selectedVehicle, let selectedSlot else { return nil }

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            return Booking(
                mall: mall,
                date: dateLabel,
                timeRange: timeRangeLabel,
                slot: selectedSlot,
                vehicle: selectedVehicle,
                voucher: selectedVoucher,
                paymentMethod: nil,
                tariffPerHour: pricePerHour,
                duration: durationLabel,
                total: total
            )
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
