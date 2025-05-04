//
//  MockData.swift
//  StudChat
//
//  Created by Karlo Šibalić on 03.05.2025..
//

import Foundation

struct MockServer: Identifiable {
    var id: Int?
    let createdAt: Date
    let name: String
}

struct MockChannel: Identifiable, Equatable {
    var id: Int?
    let createdAt: Date
    let name: String
}

var mockServers = [
    MockServer(id: 1, createdAt: .now, name: "RMA"),
    MockServer(id: 4, createdAt: .now, name: "Projekti"),
    MockServer(id: 7, createdAt: .now, name: "Chillington"),
    MockServer(id: 10, createdAt: .now, name: "Studentski Servis Official"),
    MockServer(id: 13, createdAt: .now, name: "FERIT Official"),
]

var mockChannels = [
    MockChannel(id: 1, createdAt: .now, name: "general"),
    MockChannel(id: 4, createdAt: .now, name: "android"),
    MockChannel(id: 7, createdAt: .now, name: "podcasts"),
    MockChannel(id: 10, createdAt: .now, name: "q&a"),
    MockChannel(id: 13, createdAt: .now, name: "algorithms"),
]
