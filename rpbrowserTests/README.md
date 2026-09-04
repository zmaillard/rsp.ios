# rpbrowserTests

This folder contains starter unit tests for core app behavior:

- `Models/RoadSignTests.swift`
- `Routing/DeepLinkParserTests.swift`
- `Networking/ImageLoaderViewModelTests.swift`
- `ZoomableImageViewTests.swift`

## Add a Unit Test Target in Xcode

The current project file does not include a test target yet.

1. In Xcode, choose **File > New > Target...**
2. Pick **iOS Unit Testing Bundle**
3. Name it `rpbrowserTests`
4. Set **Host Application** to `rpbrowser`
5. Ensure these files are in the `rpbrowserTests` target membership

## Run Tests

After the target is added, run Product > Test in Xcode.
