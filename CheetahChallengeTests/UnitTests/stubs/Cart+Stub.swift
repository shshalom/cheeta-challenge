//
//  Cart+Stub.swift
//  CheetahChallengeTests
//
//  Created by Shalom Shwaitzer on 30/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation

import Fakery

@testable import CheetahChallenge

extension Cart {
    static func stub(nonEmpty: Bool = false, injectedNames: [String]? = nil) -> Cart {
        let faker = Faker()
        
        var items = [[String: Any]]()
        let minCount = nonEmpty ? 1 : 0
        
        var total: Double = 0
        
        for index in 0..<faker.number.randomInt(min: minCount, max: 25) {
            
            var subTotal: Double = 0
            var name = faker.commerce.productName()
            let quantity = faker.number.randomInt(min: 1, max: 25)
            let unitPrice = faker.commerce.price()
            let casePrice = faker.commerce.price()
            let weightPrice = faker.commerce.price()
            let packageType = PackagingType(rawValue: ["unit", "case", "weight"][faker.number.randomInt(min: 0, max: 2)])!
            
            switch packageType {
            case .case: subTotal = casePrice * Double(quantity)
            case .unit: subTotal = unitPrice * Double(quantity)
            case .weight: subTotal = weightPrice * Double(quantity)
            }
            
            total += subTotal
            
            if let initialValues = injectedNames, index < initialValues.count {
                name = initialValues[index]
            }
            
            let item: [String: Any] = [
                "id": faker.number.increasingUniqueId(),
                "quantity": quantity,
                "product_id": faker.number.increasingUniqueId(),
                "sub_total": subTotal,
                "packaging_type": packageType.rawValue,
                "substitutable": faker.number.randomBool(),
                "product": [
                    "id": faker.number.increasingUniqueId(),
                    "name": name,
                    "unit_photo_hq_url": faker.internet.templateImage(),
                    "pack_photo_hq_url": faker.internet.templateImage(),
                    "available": faker.number.randomBool(),
                    "weight_photo_hq_url": faker.internet.templateImage(),
                    "unit_price": unitPrice,
                    "case_price": casePrice,
                    "weight_price": weightPrice,
                    "items_per_unit": faker.number.randomInt(min: 1, max: 10),
                    "units_per_case": faker.number.randomInt(min: 1, max: 10)
                ]]
            
             items.append(item)
        }
        
        let json: [String: Any] = [
            "id": faker.number.increasingUniqueId(),
            "cart_total": total,
            "total": faker.commerce.price(),
            "delivery_fee": faker.commerce.price(),
            "order_items_information": items]
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try! Utils.jsonDecoder.decode(Cart.self, from: data)
    }
}
