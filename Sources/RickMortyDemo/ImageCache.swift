#if canImport(SwiftUI)
#if os(macOS)
import AppKit
public typealias PlatformImage = NSImage
#else
import UIKit
public typealias PlatformImage = UIImage
#endif
import SwiftUI
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, PlatformImage>()
    private init() {}

    func image(for url: URL) -> PlatformImage? {
        cache.object(forKey: url as NSURL)
    }

    func insert(_ image: PlatformImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct CachedImageView: View {
    @State private var image: Image?
    let url: URL?

    var body: some View {
        Group {
            if let image = image {
                image.resizable()
            } else {
                ProgressView()
            }
        }
        .task(id: url) { await load() }
    }

    private func load() async {
        guard let url = url, image == nil else { return }

        if let cached = ImageCache.shared.image(for: url) {
#if os(macOS)
            image = Image(nsImage: cached)
#else
            image = Image(uiImage: cached)
#endif
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
#if os(macOS)
            guard let fetched = NSImage(data: data) else { return }
            ImageCache.shared.insert(fetched, for: url)
            image = Image(nsImage: fetched)
#else
            guard let fetched = UIImage(data: data) else { return }
            ImageCache.shared.insert(fetched, for: url)
            image = Image(uiImage: fetched)
#endif
        } catch {
            print("Image load error: \(error)")
        }
    }
}
#endif
