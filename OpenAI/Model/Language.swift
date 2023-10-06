
import Foundation

struct Language {
    let code: String
    let name: String
}

let languageCodes = ["ja", "es", "en", "vi", "tr", "it", "id", "ru", "ko", "de", "ar", "th", "sv"]

// Populate the languages array with Language instances based on the language codes
let languages: [Language] = languageCodes.map { code in
    let locale = Locale(identifier: code)
    let name = locale.localizedString(forIdentifier: code) ?? "Unknown"
    return Language(code: code, name: name)
}
