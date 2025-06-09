import SwiftUI
import RickMortySwiftApi

@MainActor
final class EpisodesViewModel: ObservableObject {
    @Published var episodes: [RMEpisodeModel] = []
    private let client = RMClient()

    func fetch() async {
        do {
            episodes = try await client.episode().getAllEpisodes()
        } catch {
            print("Error fetching episodes: \(error)")
        }
    }
}

struct EpisodesView: View {
    @StateObject private var viewModel = EpisodesViewModel()
    private let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.episodes) { episode in
                    EpisodeCardView(episode: episode)
                }
            }
            .padding()
        }
        .task { await viewModel.fetch() }
    }
}

struct EpisodeCardView: View {
    let episode: RMEpisodeModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(episode.name)
                .font(.headline)
            Text(episode.episode)
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
    EpisodesView()
}
