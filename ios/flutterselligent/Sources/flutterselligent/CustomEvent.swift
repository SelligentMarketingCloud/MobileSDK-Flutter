public class CustomEvent {
    var name: String
    var type: String
    var data: Dictionary<AnyHashable, Any>?

    init(name: String, type: String, data: Dictionary<AnyHashable, Any>?) {
        self.name = name
        self.type = type
        self.data = data
    }
}
