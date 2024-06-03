import Foundation
import ComposableArchitecture

struct APIClient {
	let url = URL(string: "http://numbersapi.com/10/trivia")!
	
	func fetch() async throws -> String {
		let (data, _) = try await URLSession.shared.data(from: url)
		return String(decoding: data, as: UTF8.self)
	}
}

extension APIClient: DependencyKey {
	static var liveValue: APIClient = APIClient()
}

extension DependencyValues {
	var apiClient: APIClient {
		get { self[APIClient.self] }
		set { self[APIClient.self] = newValue }
	}
}
