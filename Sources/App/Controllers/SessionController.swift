import Vapor
import Authentication

struct LoginRequest: Content {
    var email: String
    var password: String
}

final class SessionController {
    func new(_ req: Request) throws -> Future<View> {
        return try req.view().render("sessions/new")
    }

    func create(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(LoginRequest.self).flatMap(to: User?.self) { loginRequest in
            return User.authenticate(
                username: loginRequest.email,
                password: loginRequest.password,
                using: PlaintextVerifier(),
                on: req)
        }.map(to: Response.self) { authUser in
            guard authUser != nil else {
                throw Abort(.forbidden, reason: "Invalid email or password.")
            }
            return req.redirect(to: "/users")
        }
    }
}
