//
//  HomeViewModel.swift
//  C4_JasJus
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import Foundation
import Combine
import SwiftUI
import MapKit

@Observable
class HomeViewModel {
    var sessionState: HomeSessionState
    var remainingTime: String = "00:00:00"
    var showSearchSheet = false
    var cameraPosition: MapCameraPosition
    var navigationPath = NavigationPath()
    
    var pendingMallDetail: MallLocation?
    var selectedMall: MallLocation?
    var selectedMallID: MallLocation.ID?
    var mapMalls: [MallLocation] = []
    
    private let mallService: MallLocationServicing
    
    private var countdownCancellable: AnyCancellable?
    private var sessionCheckCancellable: AnyCancellable?
    
    init(sessionState: HomeSessionState = .empty) {
        self.sessionState = sessionState
        self.mallService = MallLocationService()
        self.cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: -6.3025, longitude: 106.6524),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        )
        startCountdownIfNeeded()
        startSessionAutoTransitionCheck()
    }
    
    private func startCountdownIfNeeded() {
        guard case .active(let session) = sessionState
        else {
            return
        }
        updateRemainingTime(until: session.endDateTime)
        
        countdownCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, case .active(let session) = self.sessionState else { return }
                self.updateRemainingTime(until: session.endDateTime)
            }
    }
    
    private func updateRemainingTime(until endDate: Date) {
        let remaining = max(0, endDate.timeIntervalSinceNow)
        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        let seconds = Int(remaining) % 60
        remainingTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        if remaining <= 0 {
            countdownCancellable?.cancel()
        }
    }
    
    private func startSessionAutoTransitionCheck() {
        sessionCheckCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkAndTransitionSession()
            }
    }
    
    private func checkAndTransitionSession() {
        guard case .upcoming(let booking) = sessionState
        else {
            return
        }
        
        let now = Date()
        
        if now >= booking.startDateTime && now <= booking.endDateTime {
            sessionState = .active(booking)
            startCountdownIfNeeded()
        }
        else if now > booking.endDateTime {
            sessionState = .empty
        }
    }
    
    func callStaff(phoneNumber: String, openURL: OpenURLAction) {
        guard let url = URL(string: "tel://\(phoneNumber)") else { return }
        openURL(url)
    }
    
    func openMaps(for session: Booking) {
        let location = CLLocation(latitude: -6.3025, longitude: 106.6524)
        let mapItem = MKMapItem(location: location, address: nil)
        mapItem.name = session.mall.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func updateSessionState(_ newState: HomeSessionState) {
        self.sessionState = newState
        startCountdownIfNeeded()
    }
    
    @MainActor
    func loadMapMalls(userLocation: CLLocationCoordinate2D?) async {
        mapMalls = (try? await mallService.fetchNearbyMalls(near: userLocation)) ?? []
    }
    
    // MARK: - Backend / MQTT (placeholder)
    // Nanti fungsi ini yang kirim request ke backend (misal POST /session/open-slot),
    // backend yang publish MQTT command ke ESP32 — app gak connect MQTT langsung.
    func openSlot() {
        // isi backend
    }
}


