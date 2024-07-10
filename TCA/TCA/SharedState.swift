//
//  SharedState.swift
//  TCA
//
//  Created by Mohamed Zaki on 10/07/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SharedRootReducer {
	@Reducer(state: .equatable)
	enum Path {
		case screen1(SharedScreen1Reducer)
		case screen2(SharedScreen2Reducer)
		case screen3(SharedScreen3Reducer)
	}
	
	@ObservableState
	struct State: Equatable {
		var path = StackState<Path.State>()
//		@Shared(.data) var sharedTitle = "shared data"
	}
	
	enum Action {
		case path(StackActionOf<Path>)
		case goToScreen1
		case goTo123
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .path(.element(id: _, action: .screen3(.delegate(.backButton(let data))))):
				state.path.removeLast()
				guard let id2 = state.path.ids.last else {return .none}
				state.path[id: id2, case: \.screen2]?.dataFrom3 = data
				return .none
				
			case .path(.element(id: _, action: .screen3(.backToRoot))):
				state.path.removeAll()
				return .none
				
			case .path(.element(id: _, action: .screen2(.delegate(.goToScreen3(let data))))):
				state.path.append(.screen3(SharedScreen3Reducer.State(title: "im screen 3", dataFromScreen2: data)))
				return .none
				
			case .path(.element(id: _, action: .screen1(.goToScreen2))):
				state.path.append(.screen2(SharedScreen2Reducer.State(title: "im screen 2")))
				return .none
				
			case .goToScreen1:
				state.path.append(.screen1(SharedScreen1Reducer.State(title: "im screen 1")))
				return .none
				
			case .goTo123:
				state.path.append(.screen1(SharedScreen1Reducer.State(title: "im screen 1")))
				state.path.append(.screen2(SharedScreen2Reducer.State(title: "im screen 2")))
				state.path.append(.screen3(SharedScreen3Reducer.State(title: "im screen 3")))
				return .none
				
			default:
				return .none
			}
		}
		.forEach(\.path, action: \.path)
	}
}

struct SharedRootView: View {
	@State var store: StoreOf<SharedRootReducer>
	var body: some View {
		NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
			VStack {
//				Text(store.sharedTitle)
				Button("Go to screen 1") {
					store.send(.goToScreen1)
				}
				Button("Go to screen 1 2 3") {
					store.send(.goTo123)
				}
			}
		} destination: { store in
			switch store.case {
			case .screen1(let store):
				SharedScreen1View(store: store)
			case .screen2(let store):
				SharedScreen2View(store: store)
			case .screen3(let store):
				SharedScreen3View(store: store)
			}
		}
	}
}

#Preview {
	SharedRootView(store: Store(initialState: SharedRootReducer.State(), reducer: {
		SharedRootReducer()
	}))
}

@Reducer
struct SharedScreen1Reducer  {
	@ObservableState
	struct State: Equatable {
		var title: String
	}
	
	enum Action {
		case goToScreen2
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			return .none
		}
	}
}

struct SharedScreen1View: View {
	let store: StoreOf<SharedScreen1Reducer>
	var body: some View {
		VStack {
			Text(store.title)
			Button("Go to screen 2") {
				store.send(.goToScreen2)
			}
		}
	}
}



@Reducer
struct SharedScreen2Reducer  {
	@ObservableState
	struct State: Equatable {
		var title: String
		var data = "data from screen 2"
		var dataFrom3 = ""
		@Shared(.data) var sharedTitle = SharedData1(title: "shared data")
	}
	
	enum Action {
		case buttonTapped
		case delegate(Delegation)
		enum Delegation {
			case goToScreen3(String)
		}
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .buttonTapped:
				return .send(.delegate(.goToScreen3(state.data)))
			default:
				return .none
			}
		}
	}
}

struct SharedScreen2View: View {
	let store: StoreOf<SharedScreen2Reducer>
	var body: some View {
		VStack {
			Text(store.title)
			Text(store.dataFrom3)
			Text(store.sharedTitle.title)
			Button("Go to screen 3") {
				store.send(.buttonTapped)
			}
		}
	}
}



@Reducer
struct SharedScreen3Reducer  {
	@ObservableState
	struct State: Equatable {
		var title: String
		var dataFromScreen2 = ""
		var data = "data from screen 3"
		@Shared(.data) var sharedTitle = SharedData1(title: "shared data")
	}
	
	enum Action {
		case backToRoot
		case backButtonTapped
		case changeShared
		case delegate(Delegation)
		enum Delegation {
			case backButton(String)
		}
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .backButtonTapped:
				return .send(.delegate(.backButton(state.data)))
			case .changeShared:
				state.sharedTitle.title = "new shared data"
				return .none
			default:
				return .none
			}
		}
	}
}

struct SharedScreen3View: View {
	let store: StoreOf<SharedScreen3Reducer>
	var body: some View {
		Text(store.title)
		Text(store.dataFromScreen2)
		Text(store.sharedTitle.title)
		Button("Back to root") {
			store.send(.backToRoot)
		}
		Button("back") {
			store.send(.backButtonTapped)
		}
		Button("change shared") {
			store.send(.changeShared)
		}
	}
}

extension PersistenceReaderKey where Self == InMemoryKey<SharedData1> {
	static var data: Self {
		inMemory("data")
	}
}

struct SharedData1: Equatable {
	var title: String
}
