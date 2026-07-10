//
//  PaymentViewModel.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation
import CoreImage.CIFilterBuiltins
import SwiftUI

@Observable
class PaymentViewModel {
    var booking: Booking
    let userId: Int?
    
    var qrImage: UIImage?
    var remainingSeconds: Int = 15 * 60
    var isCheckingStatus = false
    var errorMessage: String?

    private var timerTask: Task<Void, Never>?
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    private let service: ParkingServicing

    init(booking: Booking, userId: Int?, service: ParkingServicing = AppEnvironment.parkingService) {
        self.booking = booking
        self.userId = userId
        self.service = service
        generateQR()
        startCountdown()
    }

    deinit {
        timerTask?.cancel()
    }

    var timeRemainingLabel: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d.%02d", minutes, seconds)
    }

    func generateQR() {
        let referenceID = UUID().uuidString.prefix(12)
        let payload = "QRIS|\(booking.mall.name)|\(booking.total)|\(referenceID)"

        guard let data = payload.data(using: .utf8) else { return }
        filter.message = data
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else { return }
        let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))

        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return }
        qrImage = UIImage(cgImage: cgImage)
    }

    private func startCountdown() {
        timerTask = Task { [weak self] in
            while let self, self.remainingSeconds > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.remainingSeconds -= 1
                }
            }
        }
    }

    @MainActor
    func refreshStatus() async {
        isCheckingStatus = true
        errorMessage = nil

        if booking.backendId == nil {
            guard let userId else {
                errorMessage = "Data booking tidak lengkap."
                isCheckingStatus = false
                return
            }

            // 1. Ensure this vehicle exists on the server for THIS user → get its real id.
            var vehicleBackendId = booking.vehicle.backendId
            if vehicleBackendId == nil {
                do {
                    let vdto = try await service.registerVehicle(
                        ownerId: userId,
                        plate: booking.vehicle.licensePlate
                    )
                    booking.vehicle.backendId = vdto.id
                    vehicleBackendId = vdto.id
                    print("✅ Vehicle registered, backendId:", vdto.id)
                } catch {
                    print("❌ Vehicle register gagal:", error)
                    errorMessage = error.localizedDescription
                    isCheckingStatus = false
                    return
                }
            }

            // 2. Create the booking with the REAL vehicle id.
            let durationMinutes = Int(booking.endDateTime.timeIntervalSince(booking.startDateTime) / 60)
            do {
                let dto = try await service.createBooking(
                    userId: userId,
                    vehicleId: vehicleBackendId!,
                    durationMinutes: durationMinutes
                )
                booking.backendId = dto.id
                print("✅ Booking created, backendId:", dto.id)
            } catch {
                print("❌ Booking gagal:", error)
                errorMessage = error.localizedDescription
                isCheckingStatus = false
                return
            }
        }

        try? await Task.sleep(nanoseconds: 800_000_000)
        isCheckingStatus = false
    }
   }
