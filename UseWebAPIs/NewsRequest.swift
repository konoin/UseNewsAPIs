import Foundation

enum NewsError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct NewsRequest {
    let resourceURL: URL
    let API_KEY = "8c85459fb1a84a36a5e4bf18697cbc35"
    
    init(countryCode: String) {
        let resourceString = "https://newsapi.org/v2/top-headlines?country=\(countryCode)&category=business&apiKey=\(API_KEY)"
        
        guard let resourceURL = URL(string: resourceString) else {
fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    func getNews(completion: @escaping(Result<TotalInformation, NewsError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let newsResponse = try decoder.decode(TotalInformation.self, from: jsonData)
                let newsDetails = newsResponse.self
                completion(.success(newsDetails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        
        dataTask.resume()
    }
}
