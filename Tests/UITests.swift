import XCTest

class UITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app.launch()
    }

    func testHomeScreenHasRequiredLabels() {
        XCTAssert(app.staticTexts["Home 😀"].exists)
        XCTAssert(app.staticTexts["Count: 0"].exists)
        XCTAssert(app.staticTexts["Text: '' (length: 0)"].exists)
    }

    func testTappingButtonIncreasesCount() {
        app.buttons["Tap me!"].tap()
        XCTAssert(app.staticTexts["Count: 1"].exists)
    }

    func testEnteringTextUpdatesLabel() {
        let textField = app.textFields.elementBoundByIndex(0)
        textField.tap()
        textField.typeText("Hola")
        XCTAssert(app.staticTexts["Text: 'Hola' (length: 4)"].exists)
    }
}
