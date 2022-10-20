import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters"
    static private let privateKey = "7cafb5038f0a2e88e8e13bdaec0a04f547a4ef1d"
    static private let publicKey = "dc3a63ea70da359d895a29f35e8a98e5"
    static private let limit = 50
    
    class func loadHeros(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getcredentials()
        print(url)
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do{
                let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                onComplete(marvelInfo)
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
            
        }
    }

private class func getcredentials() -> String {
    let ts = String(Date().timeIntervalSince1970)
    let hash = MD5(ts+privateKey+publicKey).lowercased()
    return "ts=\(ts)1&apikey=\(publicKey)&hash=\(hash)"
}
}
