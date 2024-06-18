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
	}
	
	enum Action {
		case destination(PresentationAction<Destination.Action>)
		case push
		case present
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .present:
//				state.screen2State = TreeScreen2Reducer.State(title: "im screen 2")
				state.destination = .screen2(TreeScreen2Reducer.State(title: "im screen 2"))
				return .none
//			case .screen2Action:
//				return .none
//			case .screen1Action:
//				return .none
			case .push:
//				state.screen1State = TreeScreen1Reducer.State(title: "Im screen 1")
				state.destination = .screen1(TreeScreen1Reducer.State(title: "Im screen 1"))
				return .none
			case .destination:
				return .none
			}
		}
		.ifLet(\.$destination, action: \.destination)
//		.ifLet(\.$screen1State, action: \.screen1Action) {
//			TreeScreen1Reducer()
//		}
//		
//		.ifLet(\.$screen2State, action: \.screen2Action) {
//			TreeScreen2Reducer()
//		}
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
		}
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
	
	@ObservableState
	struct State: Equatable {
		var title = "Screen 1"
	}
	
	enum Action {
		case start
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
