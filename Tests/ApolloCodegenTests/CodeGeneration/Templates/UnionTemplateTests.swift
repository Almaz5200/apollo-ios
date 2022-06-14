import XCTest
import Nimble
@testable import ApolloCodegenLib
import ApolloAPI
import ApolloUtils

class UnionTemplateTests: XCTestCase {
  var subject: UnionTemplate!

  override func tearDown() {
    subject = nil

    super.tearDown()
  }

  // MARK: Helpers

  private func buildSubject(
    config: ApolloCodegenConfiguration = .mock()
  ) {
    subject = UnionTemplate(
      moduleName: "moduleAPI",
      graphqlUnion: GraphQLUnionType.mock(
        "classroomPet",
        types: [
          GraphQLObjectType.mock("cat"),
          GraphQLObjectType.mock("bird"),
          GraphQLObjectType.mock("rat"),
          GraphQLObjectType.mock("petRock")
        ]
      ),
      config: ReferenceWrapped(value: config)
    )
  }

  private func renderSubject() -> String {
    subject.template.description
  }

  // MARK: Boilerplate tests

  func test_render_generatesClosingBrace() throws {
    // given
    buildSubject()

    // when
    let actual = renderSubject()

    // then
    expect(String(actual.reversed())).to(equalLineByLine("}", ignoringExtraLines: true))
  }

  // MARK: Enum Generation Tests

  func test_render_generatesSwiftEnumDefinition() throws {
    // given
    buildSubject()

    let expected = """
    enum ClassroomPet: Union {
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test_render_givenSchemaUnion_generatesPossibleTypesProperty() throws {
    // given
    buildSubject()

    let expected = """
      public static let possibleTypes: [Object.Type] = [
        ModuleAPI.Cat.self,
        ModuleAPI.Bird.self,
        ModuleAPI.Rat.self,
        ModuleAPI.PetRock.self
      ]
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, atLine: 2, ignoringExtraLines: true))
  }

  func test_render_givenModuleType_swiftPackageManager_generatesSwiftEnum_withPublicModifier() {
    // given
    buildSubject(config: .mock(.swiftPackageManager))

    let expected = """
    public enum ClassroomPet: Union {
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test_render_givenModuleType_other_generatesSwiftEnum_withPublicModifier() {
    // given
    buildSubject(config: .mock(.other))

    let expected = """
    public enum ClassroomPet: Union {
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test_render_givenModuleType_embeddedInTarget_generatesSwiftEnum_noPublicModifier() {
    // given
    buildSubject(config: .mock(.embeddedInTarget(name: "TestTarget")))

    let expected = """
    enum ClassroomPet: Union {
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }
}
