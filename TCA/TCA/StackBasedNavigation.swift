import SwiftUI
import ComposableArchitecture

@Reducer
struct StackRootReducer {
	@Reducer(state: .equatable)
	enum Path {
		case screen1(StackScreen1Reducer)
		case screen2(StackScreen2Reducer)
		case screen3(StackScreen3Reducer)
	}
	
	@ObservableState
	struct State: Equatable {
		var path = StackState<Path.State>()
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
				state.path.append(.screen3(StackScreen3Reducer.State(title: "im screen 3", dataFromScreen2: data)))
				return .none
			case .path(.element(id: _, action: .screen1(.goToScreen2))):
				state.path.append(.screen2(StackScreen2Reducer.State(title: "im screen 2")))
				return .none
			case .goToScreen1:
				state.path.append(.screen1(StackScreen1Reducer.State(title: "im screen 1")))
				return .none
			case .goTo123:
				state.path.append(.screen1(StackScreen1Reducer.State(title: "im screen 1")))
				state.path.append(.screen2(StackScreen2Reducer.State(title: "im screen 2")))
				state.path.append(.screen3(StackScreen3Reducer.State(title: "im screen 3")))
				return .none
			default:
				return .none
			}
		}
		.forEach(\.path, action: \.path)
	}
}

struct StackRootView: View {
	@State var store: StoreOf<StackRootReducer>
	var body: some View {
		NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
			VStack {
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
				StackScreen1View(store: store)
			case .screen2(let store):
				StackScreen2View(store: store)
			case .screen3(let store):
				StackScreen3View(store: store)
			}
		}
	}
}

#Preview {
	StackRootView(store: Store(initialState: StackRootReducer.State(), reducer: {
		StackRootReducer()
	}))
}

@Reducer
struct StackScreen1Reducer  {
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

struct StackScreen1View: View {
	let store: StoreOf<StackScreen1Reducer>
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
struct StackScreen2Reducer  {
	@ObservableState
	struct State: Equatable {
		var title: String
		var data = "data from screen 2"
		var dataFrom3 = ""
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

struct StackScreen2View: View {
	let store: StoreOf<StackScreen2Reducer>
	var body: some View {
		VStack {
			Text(store.title)
			Text(store.dataFrom3)
			Button("Go to screen 3") {
				store.send(.buttonTapped)
			}
		}
	}
}



@Reducer
struct StackScreen3Reducer  {
	@ObservableState
	struct State: Equatable {
		var title: String
		var dataFromScreen2 = ""
		var data = "data from screen 3"
	}
	
	enum Action {
		case backToRoot
		case backButtonTapped
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
			default:
				return .none
			}
		}
	}
}

struct StackScreen3View: View {
	let store: StoreOf<StackScreen3Reducer>
	var body: some View {
		Text(store.title)
		Text(store.dataFromScreen2)
		Button("Back to root") {
			store.send(.backToRoot)
		}
		Button("back") {
			store.send(.backButtonTapped)
		}
	}
}
