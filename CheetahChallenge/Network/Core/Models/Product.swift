import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int
    let name: String
    let unitPhotoHqURL, packPhotoHqURL, weightPhotoHqURL: String
    let available: Bool
    let unitPrice, casePrice, weightPrice: Double
    let itemsPerUnit: Int
    let unitsPerCase: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case unitPhotoHqURL = "unit_photo_hq_url"
        case packPhotoHqURL = "pack_photo_hq_url"
        case weightPhotoHqURL = "weight_photo_hq_url"
        case available
        case unitPrice = "unit_price"
        case casePrice = "case_price"
        case weightPrice = "weight_price"
        case itemsPerUnit = "items_per_unit"
        case unitsPerCase = "units_per_case"
    }
}
