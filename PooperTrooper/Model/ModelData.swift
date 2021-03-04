import Foundation

final class ModelData: ObservableObject {
    @Published var poops: [Poop] = []
    @Published var user = User()
}
