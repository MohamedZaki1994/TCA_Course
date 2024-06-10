import SwiftUI
import ComposableArchitecture

@Reducer
struct ParentGamesReducer {
	@ObservableState
	struct State: Equatable {
		var selectedGame = "Nothing selected"
		var allGames = GamesModel.samples
		var allGamesState: IdentifiedArrayOf<GameReducer.State> = []
		var lastIndex: UUID?
		init() {
			allGamesState = IdentifiedArray(uniqueElements: allGames.map({ model in
				GameReducer.State(game: model)
			}))
		}
	}
	
	enum Action {
		case allGamesAction(IdentifiedActionOf<GameReducer>)
		case add
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .add:
				state.allGamesState.insert(GameReducer.State(game: GamesModel(name: "Silkroad", platForm: .pc)), at: 0)
				return .none
			case .allGamesAction(.element(id: let id, action: .select)):
				state.selectedGame = state.allGamesState[id: id]?.game?.name ?? ""
				if let lastIndex = state.lastIndex,
				   lastIndex != id {
					state.allGamesState[id: lastIndex]?.isGameSelected = false
				}
				state.lastIndex = id
				return .none
			case .allGamesAction(.element(id: let id, action: .remove)):
				state.allGamesState.remove(id: id)
				return .none
			}
		}
		.forEach(\.allGamesState, action: \.allGamesAction) {
			GameReducer()
		}
	}
}

struct ParentGamesView: View {
	let store: StoreOf<ParentGamesReducer>
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack {
				Text(store.selectedGame)
					.padding(.top, 10)
				Divider()
				ForEach(store.scope(state: \.allGamesState, action: \.allGamesAction)) { gameStore in
					GameView(store: gameStore)
					.padding()
				}
			}
		}
		.toolbar(content: {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					store.send(.add)
				} label: {
					Image(systemName: "plus")
				}
			}
		})
	}
}

#Preview {
	NavigationStack {
		ParentGamesView(store: Store(initialState: ParentGamesReducer.State(), reducer: {
			ParentGamesReducer()
		}))
	}
}

@Reducer
struct GameReducer {
	@ObservableState
	struct State: Equatable, Identifiable {
		let id = UUID()
		var game: GamesModel?
		var isGameSelected = false
	}
	
	enum Action {
		case select
		case remove
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .select:
				state.isGameSelected = true
				return .none
			case .remove:
				return .none
			}
		}
	}
}


struct GameView: View {
	let store: StoreOf<GameReducer>
	var body: some View {
		ZStack(alignment: .topTrailing) {
			Button(action: {
				store.send(.remove)
			}, label: {
				Image(systemName: "trash.slash")
			})
			.padding(10)
			VStack {
				Text("Game name: \(store.game?.name ?? "")")
					.padding(10)
				Text("Platform type: \(store.game?.platForm.rawValue ?? "")")
					.padding(10)
				HStack {
					if store.isGameSelected {
						Image(systemName: "checkmark")
							.foregroundStyle(Color.white)
							.padding(5)
							.background(Color.green)
							.padding(.bottom, 10)
					}
					
					Button("select this game") {
						store.send(.select)
					}
					.padding(10)
				}
			}
			.frame(width: 300)
		}
		.overlay {
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color.blue, lineWidth: 2)
		}
	}
}

#Preview {
	GameView(store: Store(initialState: GameReducer.State(game: GamesModel(name: "Guild wars", platForm: .pc)), reducer: {
		GameReducer()
	}))
}

enum Platform: String {
	case pc
	case mobile
}

struct GamesModel: Equatable, Identifiable {
	let id = UUID()
	var name: String
	var platForm: Platform
	
	static var samples: [GamesModel] {
		return [GamesModel(name: "Guild wars", platForm: .pc),
				GamesModel(name: "Clash royale", platForm: .mobile),
				GamesModel(name: "Far cry", platForm: .pc),
				GamesModel(name: "Candy crush", platForm: .mobile)
		]
	}
}
