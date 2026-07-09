import SwiftUI

struct TimeIntervalBooking: UIViewRepresentable {
    @Binding var selection: Date
    var minuteInterval: Int = 15
    var minHour: Int? = nil
    var maxHour: Int? = nil
    

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = minuteInterval
        picker.date = selection
        
        if let minHour {
            picker.minimumDate = boundaryDate(hour: minHour, minute: 0, referenceDate: selection)
        }
        if let maxHour {
            picker.maximumDate = boundaryDate(hour: maxHour, minute: 0, referenceDate: selection)
        }

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
    
    private func boundaryDate(hour: Int, minute: Int, referenceDate: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: referenceDate) ?? referenceDate
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
