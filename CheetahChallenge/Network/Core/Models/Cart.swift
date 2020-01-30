import Foundation

// MARK: - Cart
struct Cart: Codable {
    let id: Int
    let cartTotal, deliveryFee, total: Double
    let orderItemsInformation: [OrderItemsInformation]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cartTotal = "cart_total"
        case total
        case deliveryFee = "delivery_fee"
        case orderItemsInformation = "order_items_information"
    }
}
