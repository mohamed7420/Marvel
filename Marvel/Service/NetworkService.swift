//
//  NetworkService.swift
//  Marvel
//
//  Created by Mohamed Osama on 29/12/2023.
//

import Foundation
import Network


class NetworkService {
    enum NetworkError: Error {
        case notConnected
        case invalidURL
        case invalidResponse
        case badRequest
        case unauthorized
        case serverError
        case notFound
        case unknownError(statusCode: Int?)
    }

    private let session: URLSession
    private let config = ConfigurationManager.shared

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func isNetworkConnected() -> Bool {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false

        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }

        let queue = DispatchQueue.global(qos: .userInitiated)
        monitor.start(queue: queue)

        _ = semaphore.wait(timeout: .now() + 5)

            return isConnected
    }

    public func request<T: Codable>(parameters: [String: String]) async throws -> T {
        guard isNetworkConnected() else { throw NetworkError.notConnected }

        do {
            let fullURL = try? addParametersToURL(baseURL: config.baseURL, parameters: parameters)
            var request = URLRequest(url: fullURL!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            let _data = try handleMarvelErrors(statusCode: httpResponse.statusCode, data: data)

            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: _data)

            //encode data to display it as pretty json
            let prettyPrintedData = try JSONEncoder().encode(decodedData)
            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                print(prettyPrintedString)
            }
            return decodedData

        } catch {
            print(error.localizedDescription)
            throw NetworkError.unknownError(statusCode: nil)
        }
    }

    func addParametersToURL(baseURL: String, parameters: [String: String]) throws -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        guard let _ = urlComponents else {
            throw NetworkError.invalidURL
        }

        var queryItems: [URLQueryItem] = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        let timestamp = String(Date().timeIntervalSince1970)
        queryItems.append(URLQueryItem(name: "apikey", value: config.publicKey))
        queryItems.append(URLQueryItem(name: "ts", value: timestamp))
        queryItems.append(URLQueryItem(name: "hash", value: config.generateMarvelAPIHash(timestamp: timestamp)))
        queryItems.append(URLQueryItem(name: "limit", value: "20"))

        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else { return nil }

        return url
    }

    private func handleMarvelErrors(statusCode: Int, data: Data) throws -> Data {
        switch statusCode {
        case 200..<300:
            return data
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknownError(statusCode: statusCode)
        }
    }
}
