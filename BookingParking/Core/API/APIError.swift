//
//  APIError.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidResponse
    case server(statusCode: Int, message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .server(let statusCode, let message):
            switch statusCode {
            case 403:
                return message
            case 404:
                return "The requested data could not be found."
            case 409:
                return message
            case 503:
                return "The server is currently unable to connect to the parking lock. Please try again."
            default:
                return message
            }
        }
    }
}
