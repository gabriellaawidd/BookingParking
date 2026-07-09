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
    let booking: Booking

    var qrImage: UIImage?
    var remainingSeconds: Int = 15 * 60
    var isCheckingStatus = false

    private var timerTask: Task<Void, Never>?
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    init(booking: Booking) {
        self.booking = booking
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
        try? await Task.sleep(nanoseconds: 800_000_000)
        isCheckingStatus = false
    }
}
