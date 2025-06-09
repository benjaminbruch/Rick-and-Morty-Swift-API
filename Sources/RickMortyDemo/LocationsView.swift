import SwiftUI
import RickMortySwiftApi

@MainActor
final class LocationsViewModel: ObservableObject {
    @Published var locations: [RMLocationModel] = []
    private let client = RMClient()

    func fetch() async {
        do {
            locations = try await client.location().getAllLocations()
        } catch {
            print("Error fetching locations: \(error)")
        }
    }
}

struct LocationsView: View {
    @StateObject private var viewModel = LocationsViewModel()
    private let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.locations) { location in
                    LocationCardView(location: location)
                }
            }
            .padding()
        }
        .task { await viewModel.fetch() }
    }
}

struct LocationCardView: View {
    let location: RMLocationModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.headline)
            Text(location.dimension)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 150, height: 80)
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.windowBackgroundColor)))
        .shadow(radius: 2)
    }
}

#Preview {
    LocationsView()
}
