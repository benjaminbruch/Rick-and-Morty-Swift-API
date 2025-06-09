import SwiftUI
import RickMortySwiftApi

@MainActor
final class CharactersViewModel: ObservableObject {
    @Published var characters: [RMCharacterModel] = []
    private let client = RMClient()

    func fetch() async {
        do {
            characters = try await client.character().getAllCharacters()
        } catch {
            print("Error fetching characters: \(error)")
        }
    }
}

struct CharactersView: View {
    @StateObject private var viewModel = CharactersViewModel()
    private let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.characters) { character in
                    CharacterCardView(character: character)
                }
            }
            .padding()
        }
        .task { await viewModel.fetch() }
    }
}

struct CharacterCardView: View {
    let character: RMCharacterModel

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: character.image)) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Color.red
                } else {
                    ProgressView()
                }
            }
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(character.name)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.windowBackgroundColor)))
        .shadow(radius: 2)
    }
}

#Preview {
    CharactersView()
}
