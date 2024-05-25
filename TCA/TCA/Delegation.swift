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
	struct State: Equatable {
		var childState = ChildReducer.State()
		var text = ""
	}
	
	enum Action: BindableAction {
		case binding(BindingAction<State>)
		case childAction(ChildReducer.Action)
		case sendData
	}
	
	var body: some ReducerOf<Self> {
		BindingReducer()
		Scope(state: \.childState, action: \.childAction) {
			ChildReducer()
		}
		Reduce { state, action in
			switch action {
			case .binding:
				return .none
			case .childAction(.delegate(.sendFromChild)):
				print("im the parent")
				
				state.text = state.childState.title
				return .none
			case .childAction:
				return .none
			case .sendData:
				state.childState.title = state.text
				return .none
			}
		}
	}
}
struct ParentView: View {
	@State var store: StoreOf<ParentReducer>
    var body: some View {
		VStack {
			Text(store.text)
			TextField("enter a text", text: $store.text)
			Button("Send data") {
				store.send(.sendData)
			}
			Divider()
			ChildView(store: store.scope(state: \.childState, action: \.childAction))
		}
    }
}
@Reducer
struct ChildReducer {
	@ObservableState
	struct State: Equatable {
		var title = ""
	}
	
	enum Action: BindableAction {
		case binding(BindingAction<State>)
		case delegate(Delegate)
		enum Delegate {
			case sendFromChild
		}
	}
	
	var body: some ReducerOf<Self> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .binding:
				return .none
			case .delegate(.sendFromChild):
				print("im the child")
				return .none
			}
		}
	}
}
struct ChildView: View {
	@State var store: StoreOf<ChildReducer>
	var body: some View {
		VStack {
			Text(store.title)
			TextField("enter a text", text: $store.title)
			Button("sendFromChild") {
				store.send(.delegate(.sendFromChild))
			}
		}
	}
}

#Preview {
	ParentView(store: Store(initialState: ParentReducer.State(), reducer: {
		ParentReducer()
	}))
}
