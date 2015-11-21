import XCTest

class GenerateStringsCodeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    func testEmpty() {
        let (status, output) = scriptStatusAndOutputWithInputFixtureName("Empty")
        assertSuccessStatus(status, output: output, matchingFixtureName: "Empty")
    }

    func testSimpleString() {
        let (status, output) = scriptStatusAndOutputWithInputFixtureName("SimpleString")
        assertSuccessStatus(status, output: output, matchingFixtureName: "SimpleString")
    }

    func testStringWithInt() {
        let (status, output) = scriptStatusAndOutputWithInputFixtureName("StringWithInt")
        assertSuccessStatus(status, output: output, matchingFixtureName: "StringWithInt")
    }

    func testStringWithString() {
        let (status, output) = scriptStatusAndOutputWithInputFixtureName("StringWithString")
        assertSuccessStatus(status, output: output, matchingFixtureName: "StringWithString")
    }

    func testStringWithPercent() {
        let (status, output) = scriptStatusAndOutputWithInputFixtureName("StringWithPercent")
        assertSuccessStatus(status, output: output, matchingFixtureName: "StringWithPercent")
    }

    func testStringWithMultipleArgs() {
        let (status, output) = scriptStatusAndOutputWithInputFixtureName("StringWithMultipleArgs")
        assertSuccessStatus(status, output: output, matchingFixtureName: "StringWithMultipleArgs")
    }

    func testStringWithNamedArgs() {
        let (status, output) = scriptStatusAndOutputWithInputFixtureName("StringWithNamedArgs")
        assertSuccessStatus(status, output: output, matchingFixtureName: "StringWithNamedArgs")
    }

// MARK: Assertions

    func assertSuccessStatus(status: Int32, output: String, matchingFixtureName: String, file: String = __FILE__, line: UInt = __LINE__) {
        if (status != 0) {
            recordFailureWithDescription("Task failed with exit status: \(status)", inFile: file, atLine: line, expected: true)
        }

        let fixtureContent = outputFixtureContentWithName(matchingFixtureName)
        if output != fixtureContent {
            let message = "Task output does not match.\n===== Actual:\n\(output)\n===== Expected:\n\(fixtureContent)\n=====\n"
            recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
        }
    }

// MARK: Helpers

    func scriptStatusAndOutputWithInputFixtureName(fixtureName: String) -> (Int32, String) {
        let (status, output) = NSTask.statusAndStandardOutputDataFromTaskWithLaunchPath(scriptPath(), arguments: [inputFixturePathWithName(fixtureName)])
        return (status, String(data: output, encoding: NSUTF8StringEncoding)!)
    }

    func inputFixturePathWithName(fixtureName: String) -> String {
        return NSBundle(forClass: self.dynamicType).pathForResource(fixtureName, ofType: "strings", inDirectory: "Fixtures")!
    }

    func outputFixturePathWithName(fixtureName: String) -> String {
        return NSBundle(forClass: self.dynamicType).pathForResource(fixtureName, ofType: "swift", inDirectory: "Fixtures")!
    }

    func outputFixtureContentWithName(fixtureName: String) -> String {
        return try! String(contentsOfFile: outputFixturePathWithName(fixtureName))
    }

    func scriptPath() -> String {
        let bundlePath: NSString = NSBundle(forClass: self.dynamicType).bundlePath as NSString
        let containerPath: NSString = bundlePath.stringByDeletingLastPathComponent
        return containerPath.stringByAppendingPathComponent("GenerateStringsCode")
    }
}

extension NSTask {
    static func statusAndStandardOutputDataFromTaskWithLaunchPath(path: String, arguments: [String]) -> (Int32, NSData) {
        let task = NSTask()
        task.launchPath = path
        task.arguments = arguments

        let pipe = NSPipe()
        task.standardOutput = pipe

        task.launch()
        task.waitUntilExit()

        return (task.terminationStatus, pipe.fileHandleForReading.readDataToEndOfFile())
    }
}
