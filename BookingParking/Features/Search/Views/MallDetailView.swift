//
//  MallDetailView.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import SwiftUI
import MapKit

struct MallDetailView: View {
    let mall: MallLocation
    let onBookNow: (MallLocation) -> Void

    @State private var cameraPosition: MapCameraPosition
    private let pricePerHourText = "Rp5.000/hour"

    init(mall: MallLocation, onBookNow: @escaping (MallLocation) -> Void) {
        self.mall = mall
        self.onBookNow = onBookNow
        self._cameraPosition = State(wrappedValue: .region(
            MKCoordinateRegion(
                center: mall.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }

    var body: some View {
        VStack(spacing: 16) {
            mapPreview
                .padding(.top, 16)

            VStack(spacing: 6) {
                Text(mall.name)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)

                Text(mall.address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

            }
            .padding(.horizontal, 24)
            
            Text(pricePerHourText)
                .font(.headline.bold())
                .foregroundStyle(Color.accentColor)
                .padding(.bottom, 4)
            
            Button {
                onBookNow(mall)
            } label: {
                Text("Book Now")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
        }
        .padding(.top, 12)
        .padding(.bottom, 16)
    }

    private var mapPreview: some View {
        Map(position: $cameraPosition) {
            Marker(mall.name, coordinate: mall.coordinate)
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .allowsHitTesting(false)
        .padding(.horizontal)
    }
}

#Preview {
    MallDetailView(
        mall: MallLocation(
            name: "AEON Mall BSD City",
            address: "BSD Grand Boulevard Rd, Pagedangan, BSD City, Tangerang Selatan 15339",
            coordinate: .init(latitude: -6.3025, longitude: 106.6524)
        ),
        onBookNow: { _ in }
    )
    .presentationDetents([.height(420)])
}
