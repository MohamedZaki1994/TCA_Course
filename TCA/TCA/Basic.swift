//
//  Basic.swift
//  TCA
//
//  Created by Mohamed Zaki on 05/05/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct BasicReducer {
	
	@ObservableState
	struct State: Equatable {
		var counter = 0
		var isShow = true
	}
	
	enum Action {
		case incrementButtonTapped
		case decrementButtonTapped
		case toggleTapped
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .incrementButtonTapped:
				state.counter += 1
			case .decrementButtonTapped:
				state.counter -= 1
			case .toggleTapped:
				state.isShow.toggle()
			}
			return .none
		}
	}
}

struct BasicView: View {
	
	let store: StoreOf<BasicReducer>
	
	var body: some View {
		VStack {
			if store.isShow {
				Text(store.counter.description)
			}
			Button("Toggle") {
				store.send(.toggleTapped)
			}
			
			HStack {
				Button("+") {
					store.send(.incrementButtonTapped)
				}
				.buttonStyle(.bordered)
				
				Button("-") {
					store.send(.decrementButtonTapped)
				}
				.buttonStyle(.bordered)
			}
		}
		
	}
}

#Preview {
	BasicView(store: Store(initialState: BasicReducer.State(), reducer: {
		BasicReducer()
	}))
}
