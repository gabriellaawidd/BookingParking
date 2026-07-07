//
//  SearchMallModalView.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import SwiftUI
import CoreLocation

struct SearchMallModalView: View {
    @State private var viewModel: SearchMallViewModel
    @Environment(\.dismiss) private var dismiss

    let userLocation: CLLocationCoordinate2D?
    let onSelectMall: (MallLocation) -> Void

    init(
        userLocation: CLLocationCoordinate2D?,
        viewModel: SearchMallViewModel = SearchMallViewModel(),
        onSelectMall: @escaping (MallLocation) -> Void
    ) {
        self.userLocation = userLocation
        self._viewModel = State(wrappedValue: viewModel)
        self.onSelectMall = onSelectMall
    }

    var body: some View {
        VStack(spacing: 0) {
            searchBar
            sectionHeader
            content
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .task {
            await viewModel.loadNearbyMalls(userLocation: userLocation)
        }
        .onChange(of: userLocation) { _, newLocation in
            Task {
                await viewModel.loadNearbyMalls(userLocation: newLocation)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search", text: $viewModel.query)
            Image(systemName: "mic.fill")
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.horizontal)
        .padding(.top, 16)
    }

    private var sectionHeader: some View {
        HStack {
            Text(viewModel.sectionTitle)
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundStyle(.red)
                .font(.caption)
                .padding()
        } else if viewModel.results.isEmpty {
            Text("Tidak ada mall ditemukan")
                .foregroundStyle(.secondary)
                .font(.subheadline)
                .padding(.top, 40)
        } else {
            List(viewModel.results) { mall in
                Button {
                    onSelectMall(mall)
                    dismiss()   // <- sheet search langsung nutup diri sendiri
                } label: {
                    MallCard(mall: mall)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    SearchMallModalView(
        userLocation: CLLocationCoordinate2D(latitude: -6.3025, longitude: 106.6524),
        onSelectMall: { _ in }
    )
}
