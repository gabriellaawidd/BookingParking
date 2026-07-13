//
//  NotificationManager.swift
//  BookingParking
//
//  Created by Patricia Putri Gautama on 13/07/26.
//

// MARK: - NotificationManager.swift
import Foundation
import UserNotifications

final class NotificationManager: NSObject {
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func scheduleEndingSoonNotifications(for booking: Booking) {
        for minutes in [20, 15, 10, 5] {
            let triggerDate = booking.endDateTime.addingTimeInterval(-Double(minutes * 60))
            guard triggerDate > .now else { continue }

            let content = UNMutableNotificationContent()
            content.title = "Your Parking Time Is Almost Up!"
            content.body = "Your parking session will be end in \(minutes) minutes at \(booking.mall.name)!"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate),
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: "\(booking.id)-\(minutes)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request)
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
