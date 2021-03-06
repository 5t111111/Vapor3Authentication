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
            return req.redirect(to: "/users")
        }
    }

    func show(_ req: Request) throws -> Future<View> {
        let id = try req.parameters.next(Int.self)
        return try User.find(id, on: req).flatMap(to: View.self) { user in
            guard let user = user else {
                throw Abort(.notFound, reason: "Could not find user.")
            }
            let data = ["user": user]
            return try req.view().render("users/show", data)
        }
    }

    func edit(_ req: Request) throws -> Future<View> {
        let id = try req.parameters.next(Int.self)
        return try User.find(id, on: req).flatMap(to: View.self) { user in
            guard let user = user else {
                throw Abort(.notFound, reason: "Could not find user.")
            }
            let data = ["user": user]
            return try req.view().render("users/edit", data)
        }
    }

    func update(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap(to: Response.self) { decodedUser in
            let id = try req.parameters.next(Int.self)
            return try User.find(id, on: req).map(to: User.self) { user in
                guard let user = user else {
                    throw Abort(.notFound, reason: "Could not find user.")
                }
                return user
            }.flatMap(to: Response.self) { user in
                if !decodedUser.email.isEmpty {
                    user.email = decodedUser.email
                }
                if !decodedUser.password.isEmpty {
                    user.password = decodedUser.password
                }
                return user.update(on: req).map(to: Response.self) { _ in
                    return req.redirect(to: "/users")
                }
            }
        }
    }
}