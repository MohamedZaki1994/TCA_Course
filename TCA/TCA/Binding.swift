//
//  Binding.swift
//  TCA
//
//  Created by Mohamed Zaki on 10/05/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CaseBindingReducer {
	@ObservableState
	struct State: Equatable {
		var title = ""
		var title2 = ""
	}
	enum Action: BindableAction {
		case binding(BindingAction<State>)
	}
	var body: some ReducerOf<Self> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .binding(\.title2):
				print(state.title2)
				return .none
			case .binding(\.title):
				print(state.title)
				return .none
			case .binding:
				return .none
			}
		}
	}
}

struct BindingView: View {
	@State var store: StoreOf<CaseBindingReducer>

    var body: some View {
		Text(store.title)
		TextField("enter your text", text: $store.title)
		TextField("enter your text", text: $store.title2)
    }
}

#Preview {
	BindingView(store: Store(initialState: CaseBindingReducer.State(), reducer: {
		CaseBindingReducer()
	}))
}
