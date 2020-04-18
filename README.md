# The Rick and Morty API Swift Client
Swift implementation to the **awesome** [Rick and Morty API][api-link]

[![build status][travis-badge]][travis-link]
[![codecoverage][codecov-badge]][codecov-link]
[![documentation][doc-badge]][doc-link]
[![license][license-badge]][license-link]






<!-- TABLE OF CONTENTS -->
## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)


<!-- INSTALLATION -->
## Installation

For instructions how to add a Swift package to your projects look here:

[Apple - Adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)


<!-- USAGE EXAMPLES -->
## Usage

Example to get all characters as an array of character strcut:

**1. Init client:**
```swift
let rmClient = Client()
```

**2. Call character struct with function**
```swift
rmClient.character().getAllCharacters() {result in switch result {
        case .success(let characters):
            characters.forEach() { print ($0.name) }
        case.failure(let error):
            print(error)
            }
        }
```

*For more examples, please refer to the [Documentation][doc-link] or visit [Test Section][test-link]*


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
[travis-badge]: https://img.shields.io/travis/rust-lang/rust?logo=travis
[travis-link]: https://travis-ci.org/benjaminbruch/rick-morty-swift-api
[codecov-badge]: https://codecov.io/gh/benjaminbruch/rick-morty-swift-api/branch/master/graph/badge.svg
[codecov-link]: https://codecov.io/gh/benjaminbruch/rick-morty-swift-api
[doc-badge]: /docs/badge.svg
[doc-link]: https://benjaminbruch.github.io/rick-morty-swift-api/docs/index.html
[license-badge]: https://img.shields.io/github/license/benjaminbruch/rick-morty-swift-api?color=brightgreen
[license-link]: /LICENSE
[linkedinContactMe-badge]: https://img.shields.io/badge/linkedIN-CONTACT%20ME-blue?style=for-the-badge
[linkedin-link]: https://www.linkedin.com/in/benjamin-bruch
[banner-image]: https://initiate.alphacoders.com/images/812/stretched-3440-1440-812062.png?5618
[banner-link]: https://wall.alphacoders.com/big.php?i=812062&lang=German
[test-link]: /Tests/rick-morty-swift-apiTests
[api-link]:  https://rickandmortyapi.com/
