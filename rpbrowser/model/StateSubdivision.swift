struct StateSubdivision: Codable, Hashable, Identifiable, Equatable {
    let id: String
    let name: String
    let stateSlug: String
    let imageCount: Int
    let signs: [RoadSignSlim]
    
    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case stateSlug
        case imageCount
        case signs
    }
}
