import Vapor
import FluentSQLite
import Authentication

final class User: SQLiteModel, PasswordAuthenticatable, SessionAuthenticatable {
    typealias ID = Int

    static let idKey: IDKey = \User.id
    static let usernameKey: UsernameKey = \User.email
    static let passwordKey: PasswordKey = \User.password

    var id: Int?
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension User: Content {}

extension User: Migration {}
