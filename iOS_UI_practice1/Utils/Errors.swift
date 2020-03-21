//
//  Errors.swift
//  iOS_UI_practice1
//
//  Created by Alex on 15/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import Foundation

enum RequestsErrors: Error {
    case noDataReceived
    case parsingError
    case noVideoReceived
}
