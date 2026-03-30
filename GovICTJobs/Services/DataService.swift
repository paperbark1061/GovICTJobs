import Foundation
import Combine

class DataService: ObservableObject {
    static let shared = DataService()

    @Published var opportunities: [Opportunity] = []
    @Published var companies: [Company] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private init() {
        loadData()
    }

    func loadData() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            do {
                guard let url = Bundle.main.url(forResource: "opportunities", withExtension: "json") else {
                    throw DataLoadError.fileNotFound
                }

                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()

                let container = try decoder.decode(DataContainer.self, from: data)

                DispatchQueue.main.async {
                    self.opportunities = container.opportunities
                    self.companies = container.companies
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load opportunities: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

    func refreshData() {
        loadData()
    }

    func getCompanies(forOpportunity opportunity: Opportunity) -> [Company] {
        companies.filter { opportunity.matchingCompanyIds.contains($0.id) }
    }

    func getAdvertisingCompanies() -> [Company] {
        companies.filter { $0.isAdvertising }
    }

    enum DataLoadError: LocalizedError {
        case fileNotFound
        case decodingError

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "opportunities.json file not found"
            case .decodingError:
                return "Failed to decode JSON data"
            }
        }
    }
}

struct DataContainer: Codable {
    let opportunities: [Opportunity]
    let companies: [Company]
}
