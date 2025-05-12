import Security
import SwiftUI

enum KCKey: String {
    case account, password, accessToken, refreshToken
}

enum KCError: Error { case status(OSStatus) }

struct KeychainService {
    private static let service = "com.yourcompany.starbucksClone"

    static func save(_ value: Data, for key: KCKey) throws {
        let q: [String: Any] = [
            kSecClass            as String: kSecClassGenericPassword,
            kSecAttrService      as String: service,
            kSecAttrAccount      as String: key.rawValue,
            kSecValueData        as String: value,
            kSecAttrAccessible   as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemDelete(q as CFDictionary)
        let status = SecItemAdd(q as CFDictionary, nil)
        guard status == errSecSuccess else { throw KCError.status(status) }
    }

    static func read(for key: KCKey) -> Data? {
        let q: [String: Any] = [
            kSecClass        as String: kSecClassGenericPassword,
            kSecAttrService  as String: service,
            kSecAttrAccount  as String: key.rawValue,
            kSecReturnData   as String: true,
            kSecMatchLimit   as String: kSecMatchLimitOne
        ]
        var out: CFTypeRef?
        let status = SecItemCopyMatching(q as CFDictionary, &out)
        return status == errSecSuccess ? (out as? Data) : nil
    }

    static func delete(_ key: KCKey) {
        let q: [String: Any] = [
            kSecClass       as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]
        SecItemDelete(q as CFDictionary)
    }
}
