# The Rick and Morty API Swift Client
Swift implementation to the **awesome** [Rick and Morty API][api-link]

[![Swift](https://github.com/benjaminbruch/Rick-and-Morty-Swift-API/actions/workflows/swift.yml/badge.svg)](https://github.com/benjaminbruch/Rick-and-Morty-Swift-API/actions/workflows/swift.yml)
[![codecoverage][codecov-badge]][codecov-link]
[![license][license-badge]][license-link]






<!-- TABLE OF CONTENTS -->
## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)
* [Documentation][doc-link]

<!-- INSTALLATION -->
## Installation

For instructions how to add a Swift package to your projects look here:

[Apple - Adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)


<!-- USAGE EXAMPLES -->
## Usage

Example to get all characters as an array of character struct:

**1. Init client:**
```swift
let rmClient = RMClient()
```

**2. Request array of characters from server**
```swift
do {
  let characters = try await rmClient.character().getAllCharacters()
} catch (let error) {
  print(error) 
}
```

*For more examples, please refer to the [Documentation][doc-link] or visit [Test Section][test-link]*

## Demo Application

The package includes a small macOS SwiftUI demo under the `RickMortyDemo` target. Build and run this executable to see characters, episodes and locations presented in card collections. Characters are loaded lazily using pagination and images are cached for smoother scrolling.


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the repo and create your branch from master.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Issue that pull request!


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.


<!-- CONTACT -->
## Contact
[![linkedINContact][linkedinContactMe-badge]][linkedin-link]


<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [Rick and Morty API Homepage](https://rickandmortyapi.com/)
* [Rick and Morty API Github](https://github.com/afuh/rick-and-morty-api)
* [Shields.io](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Jazzy](https://github.com/realm/jazzy)
* [CodeCov](https://codecov.io)
* [TravisCI](https://travis-ci.org/)
* [Best-Readme-Template](https://github.com/othneildrew/Best-README-Template)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[travis-badge]: https://travis-ci.com/benjaminbruch/Rick-and-Morty-Swift-API.svg?
[travis-link]: https://travis-ci.com/benjaminbruch/Rick-and-Morty-Swift-API
[codecov-badge]: https://codecov.io/gh/benjaminbruch/Rick-and-Morty-Swift-API/branch/master/graph/badge.svg?token=U00WT3VHSV
[codecov-link]: https://codecov.io/gh/benjaminbruch/Rick-and-Morty-Swift-API
[doc-badge]: /docs/badge.svg
[doc-link]: https://benjaminbruch.github.io/Rick-and-Morty-Swift-API/index.html
[license-badge]: https://img.shields.io/github/license/benjaminbruch/rick-morty-swift-api?color=brightgreen
[license-link]: /LICENSE
[linkedinContactMe-badge]: https://img.shields.io/badge/linkedIN-CONTACT%20ME-blue?style=for-the-badge
[linkedin-link]: https://www.linkedin.com/in/benjamin-bruch
[banner-image]: https://initiate.alphacoders.com/images/812/stretched-3440-1440-812062.png?5618
[banner-link]: https://wall.alphacoders.com/big.php?i=812062&lang=German
[test-link]: /Tests/RickMortySwiftApiTests
[api-link]:  https://rickandmortyapi.com/
