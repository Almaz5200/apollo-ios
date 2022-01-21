import XCTest
import Nimble
@testable import ApolloCodegenLib
import ApolloCodegenTestSupport

class InterfaceFileGeneratorTests: XCTestCase {
  override func tearDown() {
    CodegenTestHelper.deleteExistingOutputFolder()

    super.tearDown()
  }

  func test_generate_givenSchemaType_shouldOutputToPath() throws {
    // given
    let rootURL = URL(fileURLWithPath: CodegenTestHelper.outputFolderURL().path)
    let fileURL = rootURL.appendingPathComponent("MockInterface.swift")
    let mockFileManager = MockFileManager(strict: false)

    mockFileManager.mock(closure: .createFile({ path, data, attributes in
      expect(path).to(equal(fileURL.path))

      return true
    }))

    // then
    try InterfaceFileGenerator(
      interfaceType: GraphQLInterfaceType.mock("MockInterface", fields: [:], interfaces: []),
      directoryPath: rootURL.path
    ).generateFile(fileManager: mockFileManager)

    expect(mockFileManager.allClosuresCalled).to(beTrue())
  }
}