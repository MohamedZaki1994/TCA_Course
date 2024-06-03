//
//  Dependency.swift
//  TCA
//
//  Created by Mohamed Zaki on 25/05/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct DependencyReducer {
	
	@Dependency(\.continuousClock) var clock
	@Dependency(\.apiClient) var apiClient
	@ObservableState
	struct State: Equatable {
		var title = "Hello"
	}
	
	enum Action {
		case buttonTapped
		case buttonResponse(String)
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .buttonTapped:
				return .run { [title = state.title] send in
//					try await clock.sleep(for: .seconds(2))
					let dataString = try await apiClient.fetch()
					let x = title
					await send(.buttonResponse(dataString))
				}
			case .buttonResponse(let newTitle):
				state.title = newTitle
				return .none
			}
		}
	}
}

struct DependencyView: View {
	let store: StoreOf<DependencyReducer>
    var body: some View {
		VStack {
			Text(store.title)
			Button("click me") {
				store.send(.buttonTapped)
			}
		}
    }
}

#Preview {
	DependencyView(store: Store(initialState: DependencyReducer.State(), reducer: {
		DependencyReducer()
	}))
}
