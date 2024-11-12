//
//  SpreadDirection.swift
//  SwiftExtensions
//
//  Created by Robert Hahn on 12.11.24.
//

import SwiftUI

public enum SpreadDirection {
	case both, horizontal, vertical, leading, trailing, top, bottom
}

extension View {
	@ViewBuilder
	public func spread(direction: SpreadDirection = .both, vAlignment: VerticalAlignment = .center, hAlignment: HorizontalAlignment = .center) -> some View {
		switch direction {
			case .both:
				HStack(alignment: vAlignment) {
					Spacer(minLength: 0)
					VStack(alignment: hAlignment) {
						Spacer(minLength: 0)
						self
						Spacer(minLength: 0)
					}
					Spacer(minLength: 0)
				}
				
			case .horizontal:
				HStack(alignment: vAlignment) {
					Spacer(minLength: 0)
					self
					Spacer(minLength: 0)
				}
				
			case .leading:
				HStack(alignment: vAlignment) {
					self
					Spacer(minLength: 0)
				}
				
			case .trailing:
				HStack(alignment: vAlignment) {
					Spacer(minLength: 0)
					self
				}
				
			case .vertical:
				VStack(alignment: hAlignment) {
					Spacer(minLength: 0)
					self
					Spacer(minLength: 0)
				}
				
			case .top:
				VStack(alignment: hAlignment) {
					self
					Spacer(minLength: 0)
				}
				
			case .bottom:
				VStack(alignment: hAlignment) {
					Spacer(minLength: 0)
					self
				}
		}
	}
}


