import Fluent
import ObjectMapper

final class <%= _.capitalize(name) %>: Entity, Mappable {
    var exists: Bool = false
    
    var id: Fluent.Node?
    <% _.each(attrs, function (attr) { %>
    var <%= attr.attrName %>: <% if (attr.attrType == 'Enum') { %><%= _.capitalize(attr.attrName) %>Enum<% } else { %><%= _.capitalize(attr.attrImplType) %><% } %>!<% }); %>

    init(<% var delim = ''; _.each(attrs, function (attr) { %><%= delim %><%= attr.attrName %>: <% if (attr.attrType == 'Enum') { %><%= _.capitalize(attr.attrName) %>Enum<% } else { %><%= _.capitalize(attr.attrImplType) %><% } %><% delim = ', '; %><% }); %>) {
        <% _.each(attrs, function (attr) { %>
        self.<%= attr.attrName %> = <%= attr.attrName %><% }); %>
    }

    init(id: Node?, <% var delim = ''; _.each(attrs, function (attr) { %><%= delim %><%= attr.attrName %>: <% if (attr.attrType == 'Enum') { %><%= _.capitalize(attr.attrName) %>Enum<% } else { %><%= _.capitalize(attr.attrImplType) %><% } %><% delim = ', '; %><% }); %>) {
        self.id = id
        <% _.each(attrs, function (attr) { %>
        self.<%= attr.attrName %> = <%= attr.attrName %><% }); %>
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        <% _.each(attrs, function (attr) { %>
        <%= attr.attrName %> = try <% if (attr.attrType == 'Enum') { %><%= _.capitalize(attr.attrName) %>Enum(rawValue: <% } %>node.extract("<%= attr.attrName %>")<% if (attr.attrType == 'Enum') { %>)!<% } %><% }); %>
    }

    func makeNode(context: Context = EmptyNode) throws -> Node {
        return try Node(node: [
            <% _.each(attrs, function (attr) { %>
            "<%= attr.attrName %>": <%= attr.attrName %><% if (attr.attrType == 'Enum') { %>.rawValue<% } %>,<% }); %>
            "id": id
        ])
    }

    required init?(map: Map) {
    }

    // Mappable
    func mapping(map: Map) {
        self.id <- (map["id"], NodeTransform())
        <% _.each(attrs, function (attr) { %>
        self.<%= attr.attrName %> <- map["<%= attr.attrName %>"]<% }); %>
    }

    static func prepare(_ database: Fluent.Database) throws {
        try database.create(entity) { builder in
            builder.id()
            <% _.each(attrs, function (attr) { %>
            builder.<%= attr.attrImplType %>("<%= attr.attrName %>")<% }); %>
        }
    }
    static func revert(_ database: Fluent.Database) throws {
        try database.delete(entity)
    }
}

extension <%= _.capitalize(name) %>: Equatable {
    static func ==(lhs: <%= _.capitalize(name) %>, rhs: <%= _.capitalize(name) %>) -> Bool {
        return lhs.id == rhs.id
    }
}
