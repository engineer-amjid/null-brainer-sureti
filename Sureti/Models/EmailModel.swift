//
//  EmailModel.swift
//  nullbrainer-sureti
//
//  Created by Amjad on 20/04/2022.
//

import Foundation
struct EmailModel: Decodable {
    let message: String?
    let requestedAction: Bool?

    enum CodingKeys: String, CodingKey {
        case message
        case requestedAction = "Requested_Action"
    }
}

