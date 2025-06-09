#if os(Linux)
import Foundation

@main
enum LinuxMain {
    static func main() {
        fatalError("RickMortyDemo is only supported on macOS/iOS")
    }
}
#endif
