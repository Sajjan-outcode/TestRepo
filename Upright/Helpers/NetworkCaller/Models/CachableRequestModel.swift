import Foundation

struct CachableRequestModel: Codable {
    var path: String
    var httpMethodString: String
    var base64EncodedCachedDataString: String
    var contentType: String
    
    var cachedData: Data {
        return Data(base64Encoded: base64EncodedCachedDataString)!
    }
    
    var httpMethod: HTTPMethods? {
        switch httpMethodString.lowercased() {
        case "put":
            return .put
        case "patch":
            return .patch
        case "post":
            return .post
        case "get":
            return .get
        default:
            return nil
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case path, httpMethodString, base64EncodedCachedDataString, contentType
    }
}
