//struct AppUrls {
//
//    static let host = AppTarget.currentTarget.host
//    static let scheme = AppTarget.currentTarget.scheme
//
//    private static let urlBuilder = URLBuilder().set(scheme: scheme).set(host: host)
//        .set(port: AppTarget.currentTarget.port)
//
//    private static let stagingUrlBuilder = URLBuilder().set(scheme: scheme).set(host: host)
//    private static let version = "v1"
//
//    static func getAppUrl(fromPath path: String) -> URL? {
//        return AppUrls.urlBuilder.set(path: "api/\(version)/\(path)").build()
//    }
//
//    static func getAppWebUrl(fromPath path: String) -> URL? {
//        return AppUrls.urlBuilder.set(path: "\(path)").build()
//    }
//
//    static func getSocketUrl() -> URL? {
//        return AppUrls.stagingUrlBuilder.build()
//    }
//
//}
