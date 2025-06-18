import Moya

import Foundation



enum GooglePlaceAPI {
    
    case textSearch(query: String)
    
}

extension GooglePlaceAPI: TargetType {
    
    var baseURL: URL {
        
        return URL(string: "https://maps.googleapis.com/maps/api/place")!
        
    }
    
    var path: String {
        
        switch self {
            
        case .textSearch:
            
            return "/textsearch/json"
            
        }
        
    }
    
    
    var method: Moya.Method {
        
        return .get
        
    }
    
    
    var task: Task {
        
        switch self {
            
        case .textSearch(let query):
            
            let gmsApiKey = Config.googleMapsKey
            
            return .requestParameters(parameters: [
                
                "query": query,
                
                "key": gmsApiKey
                
            ], encoding: URLEncoding.queryString)
            
        }
        
    }
 
    var headers: [String: String]? {
        
        return [
            
            "Accept": "application/json",
            
            //"Accept-Encoding": "gzip"
            
        ]
        
    }
    
    
    
    var sampleData: Data {
        
        return Data()
        
    }
    
}
