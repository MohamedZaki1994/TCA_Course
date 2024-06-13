import SwiftUI
import ComposableArchitecture

@Reducer
struct TreeReducer {
	@ObservableState
	struct State: Equatable {
		@Presents var screen1State: TreeScreen1Reducer.State?
	}
	
	enum Action {
		case screen1Action(PresentationAction<TreeScreen1Reducer.Action>)
		case push
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .screen1Action:
				return .none
			case .push:
				state.screen1State = TreeScreen1Reducer.State(title: "Im screen 1")
				return .none
			}
		}
		.ifLet(\.$screen1State, action: \.screen1Action) {
			TreeScreen1Reducer()
		}
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
		}
		.navigationDestination(item: $store.scope(state: \.screen1State, action: \.screen1Action)) { store in
			TreeScreen1View(store: store)
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
	@ObservableState
	struct State: Equatable {
		var title = "Screen 1"
	}
	
	enum Action {}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			return .none
		}
	}
}

struct TreeScreen1View: View {
	let store: StoreOf<TreeScreen1Reducer>
	var body: some View {
		Text(store.title)
	}
}
