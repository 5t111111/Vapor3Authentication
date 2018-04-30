import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let userController = UserController()
    router.get("users", use: userController.index)
    router.post("users", use: userController.create)
    router.get("users", "new", use: userController.new)
    router.get("users", Int.parameter, use: userController.show)
    router.get("users", "edit", Int.parameter, use: userController.edit)
    router.post("users", Int.parameter, use: userController.update)
}
