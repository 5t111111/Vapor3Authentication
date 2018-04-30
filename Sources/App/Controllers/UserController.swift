import Vapor

final class UserController {
    func index(_ req: Request) throws -> Future<View> {
        let allUsers = User.query(on: req).all()
        return allUsers.flatMap(to: View.self) { users in
            let data = ["users": users]
            return try req.view().render("users/index", data)
        }
    }

    func new(_ req: Request) throws -> Future<View> {
        return try req.view().render("users/new")
    }

    func create(_ req: Request) throws -> Future<Response> {
        let user = try req.content.decode(User.self)
        return user.save(on: req).map(to: Response.self) { _ in
            return req.redirect(to: "users")
        }
    }

    func show(_ req: Request) throws -> Future<View> {
        let id = try req.parameters.next(Int.self)
        let userFuture = try User.find(id, on: req)
        return userFuture.flatMap(to: View.self) { user in
            guard let unWrappedUser = user else {
                throw Abort(.badRequest, reason: "User is not found")
            }
            let data = ["user": unWrappedUser]
            return try req.view().render("users/show", data)
        }
    }
}