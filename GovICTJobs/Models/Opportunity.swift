import Foundation

struct Opportunity: Identifiable, Codable {
    let id: String
    let title: String
    let buyer: String
    let arrangement: String
    let location: String
    let closing: String
    let module: String
    let category: String
    let matchingCompanyIds: [String]

    enum CodingKeys: String, CodingKey {
        case id, title, buyer, arrangement, location, closing, module, category
        case matchingCompanyIds = "matchingCompanyIds"
    }

    var skills: [String] {
        extractSkillsFromTitle(title)
    }

    var moduleColor: String {
        switch module.lowercased() {
        case let m where m.contains("labour"):
            return "blue"
        case let m where m.contains("professional"):
            return "green"
        case let m where m.contains("rfi"):
            return "orange"
        default:
            return "gray"
        }
    }

    private func extractSkillsFromTitle(_ title: String) -> [String] {
        let titleLower = title.lowercased()
        var extractedSkills: [String] = []

        let skillPatterns: [(String, String)] = [
            (".NET", ".NET|dot net|dotnet"),
            ("SAP", "sap"),
            ("Cyber", "cyber|security|infosec"),
            ("Cloud", "cloud|aws|azure|gcp|openstack"),
            ("Testing", "testing|qa|qc|automation|test"),
            ("Java", "java(?!script)"),
            ("Oracle", "oracle|plsql|pl/sql"),
            ("Data", "data(?!base)|analytics|bi|business intelligence|dwh|data warehouse"),
            ("UX", "ux|user experience|ui design|design|frontend"),
            ("Infrastructure", "infrastructure|sysadmin|sys admin|windows|linux|unix"),
            ("DevOps", "devops|ci/cd|deployment|containerization|docker|kubernetes"),
            ("Project Management", "pmp|project manager|project management|scrum|agile|prince2"),
        ]

        for (skillName, pattern) in skillPatterns {
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            if let regex = regex, regex.firstMatch(in: titleLower, range: NSRange(titleLower.startIndex..., in: titleLower)) != nil {
                if !extractedSkills.contains(skillName) {
                    extractedSkills.append(skillName)
                }
            }
        }

        return extractedSkills.sorted()
    }
}
