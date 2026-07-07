import Foundation
import Combine

@MainActor
final class BookingFormViewModel: ObservableObject {
    let mall: Mall

    @Published var selectedVehicle: Vehicle?
    @Published var availableVehicles: [Vehicle] = []
    @Published var isLoadingVehicles: Bool = false

    @Published var selectedSlot: String?
    @Published var selectedVoucher: String?
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var durationHours: Int = 2
    @Published var bookingDate: Date?

    @Published var isSubmitting: Bool = false
    @Published var errorMessage: String?

    private let vehicleService: VehicleServiceProtocol

    init(mall: Mall, vehicleService: VehicleServiceProtocol = MockVehicleService()) {
        self.mall = mall
        self.vehicleService = vehicleService
        loadVehicles()
    }

    func loadVehicles() {
        Task {
            isLoadingVehicles = true
            defer { isLoadingVehicles = false }
            do {
                availableVehicles = try await vehicleService.fetchVehicles()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    var isFormValid: Bool {
        selectedVehicle != nil && selectedSlot != nil
    }

    var total: Int {
        mall.pricePerHour * durationHours
    }

    var durationLabel: String {
        guard let startTime = startTime, let endTime = endTime else { return "\(durationHours) hours" }
        let components = Calendar.current.dateComponents([.hour, .minute], from: startTime, to: endTime)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        return "\(hours) hours, \(minutes) minutes"
    }

    var timeRangeLabel: String {
        guard let startTime = startTime, let endTime = endTime else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
    
    var dateLabel: String {
        guard let date = bookingDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }
    
    var dayRangeLabel: String {
        guard let day = bookingDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: day)

    }

    func submitBooking() async -> Booking? {
        guard isFormValid, let vehicle = selectedVehicle, let slot = selectedSlot else { return nil }

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            return Booking(
                mall: mall,
                date: dateLabel,              // <-- diisi dari bookingDate
                timeRange: timeRangeLabel,
                slot: slot,
                vehicle: vehicle,
                voucher: selectedVoucher,
                paymentMethod: nil,
                tariffPerHour: mall.pricePerHour,
                duration: durationLabel,
                total: total
            )
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func syncFromDraft(_ router: AppRouter) {
        guard let slot = router.draftSlotID else { return }

        selectedSlot = slot

        if let date = router.draftDate {
            bookingDate = date
        }

        if let start = router.draftStartTime, let end = router.draftEndTime {
            startTime = start
            endTime = end
            let components = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
            let totalMinutes = (components.hour ?? 0) * 60 + (components.minute ?? 0)
            durationHours = max(Int(ceil(Double(totalMinutes) / 60.0)), 1)
//            durationHours = max(totalMinutes, 60) / 60  //INI
            
//            let hours = Calendar.current.dateComponents([.hour], from: start, to: end).hour ?? 1
//            durationHours = max(hours, 1)   // minimal 1 jam, jaga2 kalau end < start
        }
    }
}
