import Foundation

struct NetworkKeys {
    static let DeviceType = "ios"
    
    struct UserDefaults {
        static let requestCache = "request_cache"
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
        static let deviceToken = "device_token"
    }
    
    struct Headers {
        static let Authorization = "Authorization"
        static let apiKey = "x-api-key"
        static let ContentType = "Content-Type"
        static let removeAuthorization = "removeAuthorization"
        static let DeviceId = "deviceid"
        static let Platform = "devicetype"
        static let AppVersion = "appversion"
        static let Locale = "Locale"
    }
    
    struct LanguageCode {
        static let English = "en"
    }
}
