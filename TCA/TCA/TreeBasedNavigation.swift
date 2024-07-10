import SwiftUI
import ComposableArchitecture

@Reducer
struct TreeReducer {
	@ObservableState
	struct State: Equatable {
		@Presents var destination: Destination.State?
	}
	
	@Reducer(state: .equatable)
	enum Destination {
		case screen1(TreeScreen1Reducer)
		case screen2(TreeScreen2Reducer)
		case alert(AlertState<Alert>)
		enum Alert {
			case ok
			case cancel
		}
	}
	
	enum Action {
		case destination(PresentationAction<Destination.Action>)
		case push
		case present
		case alert
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .alert:
				let alert = AlertState<Destination.Alert> {
					TextState("Title")
				}
			actions: {
				ButtonState(role: .destructive, action: .ok) {
					TextState("Ok")
				}
				ButtonState(role: .cancel, action: .cancel) {
					TextState("Cancel")
				}
			}
			message: {
					TextState("desc")
				}
				state.destination = .alert(alert)
				return .none
			case .present:
				state.destination = .screen2(TreeScreen2Reducer.State(title: "im screen 2"))
				return .none
			case .push:
				state.destination = .screen1(TreeScreen1Reducer.State(title: "Im screen 1"))
				return .none
			case .destination(.presented(.screen1(.start))):
				print("start")
				return .none
			case .destination(.presented(.alert(.ok))):
				print("ok")
				return .none
			case .destination:
				return .none
			}
		}
		.ifLet(\.$destination, action: \.destination)
	}
}

struct TreeView: View {
	@State var store: StoreOf<TreeReducer>
	
	var body: some View {
		VStack {
			Text("Root tree")
			Button("push screen") {
				store.send(.push)
			}
			
			Button("present screen") {
				store.send(.present)
			}
			
			Button("show alert") {
				store.send(.alert)
			}
		}
		.alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
		.navigationDestination(item: $store.scope(state: \.destination?.screen1, action: \.destination.screen1)) { store in
			TreeScreen1View(store: store)
		}
		.sheet(item: $store.scope(state: \.destination?.screen2, action: \.destination.screen2)) { store in
			TreeScreen2View(store: store)
		}
	}
}

#Preview {
	NavigationStack {
		TreeView(store: Store(initialState: TreeReducer.State(), reducer: {
			TreeReducer()
		}))
	}
}

@Reducer
struct TreeScreen1Reducer {
	@Dependency(\.continuousClock) var clock
	@Dependency(\.dismiss) var dismiss
	@ObservableState
	struct State: Equatable {
		var title = "Screen 1"
	}
	
	enum Action {
		case start
		case close
	}
	private enum CancelId { case cancel }
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .start:
				return .run { send in
					try await clock.sleep(for: .seconds(2))
					print("clock finished")
				}.cancellable(id: CancelId.cancel)
			case .close:
				return .run { send in
				await dismiss()
				}
			}
		}
	}
}

struct TreeScreen1View: View {
	let store: StoreOf<TreeScreen1Reducer>
	var body: some View {
		VStack {
			Text(store.title)
			Button("start effect") {
				store.send(.start)
			}
			Button("close") {
				store.send(.close)
			}
		}
	}
}

@Reducer
struct TreeScreen2Reducer {
	@ObservableState
	struct State: Equatable {
		var title = ""
	}
	
	enum Action {}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			return .none
		}
	}
}

struct TreeScreen2View: View {
	let store: StoreOf<TreeScreen2Reducer>
	
	var body: some View {
		Text(store.title)
	}
}
