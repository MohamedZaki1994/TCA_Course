import SwiftUI
import ComposableArchitecture

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

struct SharedScreen3View: View {
	let store: StoreOf<SharedScreen3Reducer>
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
