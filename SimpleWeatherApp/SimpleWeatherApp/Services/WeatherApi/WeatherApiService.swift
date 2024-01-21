//
//  WeatherAlertApiService.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import Foundation

protocol WeatherApi {
    func fetchWeatherAlerts(completion: @escaping (Result<[WeatherAlert], WeatherApiServiceError>) -> Void)
}

final class WeatherApiService {
    private let baseURLString = "https://api.weather.gov/alerts/active"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension WeatherApiService: WeatherApi {
    func fetchWeatherAlerts(completion: @escaping (Result<[WeatherAlert], WeatherApiServiceError>) -> Void) {
        guard let url = constructURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unexpectedResponse))
                return
            }
            
            self?.handleResponse(httpResponse, data: data, completion: completion)
        }
        task.resume()
    }
}

private extension WeatherApiService {
    func handleResponse(_ httpResponse: HTTPURLResponse,
                        data: Data?,
                        completion: @escaping (Result<[WeatherAlert], WeatherApiServiceError>) -> Void) {
        guard 200..<300 ~= httpResponse.statusCode else {
            completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(.noData))
            return
        }
        
        decodeData(data, completion: completion)
    }
    
    func decodeData(_ data: Data, 
                    completion: @escaping (Result<[WeatherAlert], WeatherApiServiceError>) -> Void) {
        do {
            let decodedResponse = try JSONDecoder().decode(FeatureCollection.self, from: data)
            let alerts = decodedResponse.features.map { $0.properties }
            completion(.success(alerts))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
    
    func constructURL() -> URL? {
        var components = URLComponents(string: baseURLString)
        components?.queryItems = [
            URLQueryItem(name: QueryParamKeys.status, value: QueryParamValues.actual),
            URLQueryItem(name: QueryParamKeys.messageType, value: QueryParamValues.alert)
        ]
        return components?.url
    }
    
    enum QueryParamKeys {
        static let status = "status"
        static let messageType = "message_type"
    }
    
    enum QueryParamValues {
        static let actual = "actual"
        static let alert = "alert"
    }
}
