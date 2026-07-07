// MARK: - TimeIntervalBooking.swift
import SwiftUI

struct TimeIntervalBooking: UIViewRepresentable {
    @Binding var selection: Date
    var minuteInterval: Int = 15

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = minuteInterval
        picker.date = selection
        picker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.dateChanged(_:)),
            for: .valueChanged
        )
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        if uiView.date != selection {
            uiView.date = selection
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject {
        let parent: TimeIntervalBooking

        init(_ parent: TimeIntervalBooking) {
            self.parent = parent
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selection = sender.date
        }
    }
}
