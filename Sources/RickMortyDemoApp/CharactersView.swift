import SwiftUI
import RickMortySwiftApi

struct CharactersView: View {
    @State private var characters: [RMCharacterModel] = []
    @State private var isLoading = true
    private let client = RMClient()

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    List(characters) { character in
                        CharacterCard(character: character)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Characters")
        }
        .task {
            await loadCharacters()
        }
    }

    private func loadCharacters() async {
        do {
            characters = try await client.character().getAllCharacters()
        } catch {
            print("Error fetching characters: \(error)")
        }
        isLoading = false
    }
}

struct CharacterCard: View {
    let character: RMCharacterModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)
                    Text(character.species)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 2))
    }
}

#Preview {
    CharactersView()
}
