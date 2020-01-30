import Foundation

// MARK: - OrderItemsInformation
struct OrderItemsInformation: Codable {
    let id, quantity, productID: Int
    let subTotal: Double
    let packagingType: PackagingType
    let substitutable: Bool
    let product: Product

    enum CodingKeys: String, CodingKey {
        case id, quantity
        case productID = "product_id"
        case subTotal = "sub_total"
        case packagingType = "packaging_type"
        case substitutable, product
    }
}
