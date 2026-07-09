//
//  APIClient.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

struct APIClient {
    static let baseURL = URL(string: "http://localhost:3000")!
    
    func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body
    ) async throws -> Response {
        var request = URLRequest(url: Self.baseURL.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try Self.validate(response, data: data)
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
    func get<Response: Decodable>( _path: String) async throws -> Response {
        let url = Self.baseURL.appendingPathComponent(_path)
        let (data, response) = try await URLSession.shared.data(from: url)
        try Self.validate(response, data: data)
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
    private static func validate(_ response: URLResponse?, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            if let errorBody = try? JSONDecoder().decode(APIErrorBody.self, from: data) {
                throw APIError.server(statusCode: httpResponse.statusCode, message: errorBody.error)
            }
            throw APIError.server(statusCode: httpResponse.statusCode, message: "Unknown error")
        }
    }
}

private struct APIErrorBody: Decodable {
    let error: String
}
