//
//  BestContrastColorTests.swift
//  SwiftExtensions
//
//  Created by Robert Hahn on 14.11.25.
//


import SwiftUI
import Testing

import SwiftExtensions

@Suite("BestContrastColor alpha-aware tests")
struct BestContrastColorTests {
    // Helper to compare two Colors by converting to RGBA in device RGB space
    func isColor(_ color: Color, equalTo other: Color, in colorSpace: NSColorSpace = .deviceRGB) -> Bool {
        #if os(iOS)
        func rgba(_ c: Color) -> (CGFloat, CGFloat, CGFloat, CGFloat)? {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            guard let ui = UIColor(c).usingColorSpace(colorSpace),
                  ui.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
            return (r,g,b,a)
        }
        #elseif os(macOS)
        func rgba(_ c: Color) -> (CGFloat, CGFloat, CGFloat, CGFloat)? {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            guard let ns = NSColor(c).usingColorSpace(colorSpace) else { return nil }
            ns.getRed(&r, green: &g, blue: &b, alpha: &a)
            return (r,g,b,a)
        }
        #endif
        guard let lhs = rgba(color), let rhs = rgba(other) else { return false }
        let eps: CGFloat = 0.001
        return abs(lhs.0 - rhs.0) < eps && abs(lhs.1 - rhs.1) < eps && abs(lhs.2 - rhs.2) < eps
    }

    #if os(iOS)
    private var oppositeOfPrimary: Color { Color(UIColor.systemBackground) }
    #elseif os(macOS)
    private var oppositeOfPrimary: Color { Color(NSColor.windowBackgroundColor) }
    #endif

    @Test("Opaque light color prefers black text")
    func opaqueLightPrefersBlack() {
        let bg = Color(red: 0.9, green: 0.9, blue: 0.9)
        let best = bg.bestContrastColor()
        #expect(isColor(best, equalTo: .primary))
    }

    @Test("Opaque dark color prefers opposite of primary color text")
    func opaqueDarkPrefersWhite() {
        let bg = Color(red: 0.1, green: 0.1, blue: 0.1)
        let best = bg.bestContrastColor()
        #expect(isColor(best, equalTo: oppositeOfPrimary))
    }

    @Test("Semi-transparent light color biases darker (primary color text)")
    func translucentLightBiasesWhite() {
        let bg = Color(.sRGB, red: 0.9, green: 0.9, blue: 0.9, opacity: 0.3)
        let best = bg.bestContrastColor()
		#expect(isColor(best, equalTo: .primary))
    }

    @Test("Nearly transparent color prefers primary color text")
    func nearlyTransparentPrefersWhite() {
        let bg = Color(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 0.05)
        let best = bg.bestContrastColor()
        #expect(isColor(best, equalTo: .primary))
    }

    @Test("Mid alpha light color around threshold")
    func midAlphaLightThreshold() {
        let bg = Color(.sRGB, red: 0.8, green: 0.8, blue: 0.8, opacity: 0.5)
        let best = bg.bestContrastColor()
        // With alpha scaling, this should lean toward a light-ish semantic color (opposite of primary)
        #expect(isColor(best, equalTo: oppositeOfPrimary))
    }
}

