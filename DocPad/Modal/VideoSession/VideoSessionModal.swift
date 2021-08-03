//
//  VideoSessionModal.swift
//  DocPad
//
//  Created by Parminder Singh on 05/04/20.
//  Copyright © 2020 DeftDeskSol. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Welcome
struct VideoSessionModal: Codable {
    let currentPage, pageSize, totalResults, personid: Int?
    let sortFields, sortDirections: String?
    let filterBy, filterValue: String?
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let id: Int
    let meetingURL: String?
    let creationDate: Double?
    let createdBy: Int?
    let invitationType: String?
    let isdCode: String?
    let mailTo, smsTo: String?
    let sessionName, roomID, providerName: String?
    let status: String?
    let applicationUserTo: Int?
    let createdbyName: String?
    let applicationUserName: String?
    let allParticipants: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, meetingURL, creationDate, createdBy, invitationType, isdCode, mailTo, smsTo, sessionName, providerName
        case roomID = "roomId"
        case status, applicationUserTo, createdbyName, applicationUserName, allParticipants
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

