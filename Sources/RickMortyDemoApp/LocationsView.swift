import SwiftUI
import RickMortySwiftApi

struct LocationsView: View {
    @State private var locations: [RMLocationModel] = []
    @State private var isLoading = true
    private let client = RMClient()

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    List(locations) { location in
                        LocationCard(location: location)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Locations")
        }
        .task {
            await loadLocations()
        }
    }

    private func loadLocations() async {
        do {
            locations = try await client.location().getAllLocations()
        } catch {
            print("Error fetching locations: \(error)")
        }
        isLoading = false
    }
}

struct LocationCard: View {
    let location: RMLocationModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.headline)
            Text(location.type)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(location.dimension)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 2))
    }
}

#Preview {
    LocationsView()
}
