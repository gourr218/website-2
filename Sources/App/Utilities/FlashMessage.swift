import Vapor

enum FlashMessage {

    enum Error {
        static func invalidRegisterValues(for res: Response) -> Response {
            return res.flash(
                .error,
                "Email invalid or Password too short"
            )
        }

        static func emailNotUnique(for res: Response) -> Response {
            return res.flash(
                .error,
                "Email already exists"
            )
        }

        static func invalidLoginValues(for res: Response) -> Response {
            return res.flash(
                .error,
                "Email or Password invalid"
            )
        }
    }

    enum Success {
        static func successfulRegistration(for res: Response) -> Response {
            return res.flash(
                .success,
                "Successfully registered"
            )
        }
    }
}
