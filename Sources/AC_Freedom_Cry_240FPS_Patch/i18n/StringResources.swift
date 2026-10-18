import Foundation

#if os(Windows)
import WinSDK
#endif

enum Localized {
    private static let currentLanguage: String = {
        #if os(Windows)
        var langName = [WCHAR](repeating: 0, count: 85)
        let length = GetUserDefaultLocaleName(&langName, Int32(langName.count))
        if length > 0 {
            let locale = String(decodingCString: langName, as: UTF16.self)
            if locale.lowercased().hasPrefix("pt") {
                return "pt-BR"
            }
        }
        #endif
        return "en"
    }()

    private static let activeDictionary: [String: String] = {
        switch currentLanguage {
        case "pt-BR":
            return BrazillianPortugueseDictionary.strings
        default:
            return EnglishDictionary.strings
        }
    }()

    static func string(_ key: String) -> String {
        return activeDictionary[key] ?? key
    }

    static subscript(key: String) -> String {
        return activeDictionary[key] ?? key
    }
}