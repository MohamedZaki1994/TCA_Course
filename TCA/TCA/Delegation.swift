//
//  Delegation.swift
//  TCA
//
//  Created by Mohamed Zaki on 11/05/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ParentReducer {
	@ObservableState
	struct State: Equatable {}
	
	enum Action {}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			return .none
		}
	}
}
struct ParentView: View {
	let store: StoreOf<ParentReducer>
    var body: some View {
        Text("Hello, World!")
    }
}
@Reducer
struct ChildReducer {
	@ObservableState
	struct State: Equatable {}
	
	enum Action {}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			return .none
		}
	}
}
struct ChildView: View {
	let store: StoreOf<ChildReducer>
	var body: some View {
		Text("Hello iam view 2")
	}
}

#Preview {
	ParentView(store: Store(initialState: ParentReducer.State(), reducer: {
		ParentReducer()
	}))
}
