import Testing
@testable import SwiftExtensions

@Suite("OptionalOperatorsTests")
struct OptionalOperatorsTests {
    @Test("Optional assignment operator should not modify target when source is nil")
    func assignNilToNonNil() async throws {
        // Given
        var target: String = "target"
        let source: String? = nil
        
        // When
        target <-?? source
        
        // Then
        #expect(target == "target", "Target value should remain unchanged when source is nil")
    }
    
    @Test("Optional assignment operator should update target when source is non-nil")
    func assignNonNilToNonNil() async throws {
        // Given
        var target: String = "target"
        let source: String? = "source"
        
        // When
        target <-?? source
        
        // Then
        #expect(target == "source", "Target value should be updated to source value")
    }
    
    @Test("Optional assignment operator should keep target nil when source is nil")
    func assignNilToNil() async throws {
        // Given
        var target: String? = nil
        let source: String? = nil
        
        // When
        target <-?? source
        
        // Then
        #expect(target == nil, "Target should remain nil when source is nil")
    }
    
    @Test("Optional assignment operator should update nil target with non-nil source")
    func assignNonNilToNil() async throws {
        // Given
        var target: String? = nil
        let source: String? = "source"
        
        // When
        target <-?? source
        
        // Then
        #expect(target == "source", "Target should be updated with non-nil source value")
    }
}
