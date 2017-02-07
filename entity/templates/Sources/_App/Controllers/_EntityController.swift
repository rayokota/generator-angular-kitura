import Foundation

import Kitura
import LoggerAPI
import SwiftyJSON
import Node
import ObjectMapper

public final class <%= _.capitalize(name) %>Controller {
    public let path = "<%= baseName %>/<%= pluralize(name) %>"

    public func setupRoutes(_ router: Router) {
        let id = "\(path)/:id"

        router.get("/\(path)/", handler: onGetAll)
        router.post("/\(path)/", handler: onAdd)
        router.put(id, handler: onUpdateByID)
        router.get(id, handler: onGetByID)
        router.delete(id, handler: onDeleteByID)
    }

    private func onGetAll(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        do {
            let json = try Mapper().toJSONArray(<%= _.capitalize(name) %>.all())
            response.status(.OK).send(json: JSON(json))
            next()
        } catch {
            response.status(.internalServerError)
            next()
        }
    }

    private func onGetByID(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let id = request.parameters["id"] else {
            Log.error("Request does not contain ID")
            response.status(.badRequest)
            next()
            return
        }

        do {
            let entity = try <%= _.capitalize(name) %>.find(Node.number(.int(Int(id)!)))!
            let json = Mapper().toJSON(entity)
            response.status(.OK).send(json: JSON(json))
            next()
        } catch {
            response.status(.internalServerError)
            next()
        }
    }

    private func onAdd(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let body = request.body else {
            Log.error("No body found in request")
            response.status(.badRequest)
            next()
            return
        }

        guard case let .json(json) = body else {
            Log.error("Body contains invalid JSON")
            response.status(.badRequest)
            next()
            return
        }

        <% _.each(attrs, function (attr) { %>
        let <%= attr.attrName %> = <% if (attr.attrType == 'Enum') { %><%= _.capitalize(attr.attrName) %>Enum(rawValue: <% } %>json["<%= attr.attrName %>"].<%= attr.attrImplType %>Value<% if (attr.attrType == 'Enum') { %>)!<% } %><% }); %>

        do {
            var entity = <%= _.capitalize(name) %>(<% var delim = ''; _.each(attrs, function (attr) { %><%= delim %><%= attr.attrName %>: <%= attr.attrName %><% delim = ', '; %><% }); %>)
            try entity.save()
            let json = Mapper().toJSON(entity)
            response.status(.OK).send(json: JSON(json))
            next()
        } catch {
            response.status(.internalServerError)
            next()
        }
    }

    private func onUpdateByID(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let id = request.parameters["id"] else {
            Log.error("id parameter not found in request")
            response.status(.badRequest)
            next()
            return
        }

        guard let body = request.body else {
            Log.error("No body found in request")
            response.status(.badRequest)
            next()
            return
        }

        guard case let .json(json) = body else {
            Log.error("Body contains invalid JSON")
            response.status(.badRequest)
            next()
            return
        }

        <% _.each(attrs, function (attr) { %>
        let <%= attr.attrName %> = <% if (attr.attrType == 'Enum') { %><%= _.capitalize(attr.attrName) %>Enum(rawValue: <% } %>json["<%= attr.attrName %>"].<%= attr.attrImplType %>Value<% if (attr.attrType == 'Enum') { %>)!<% } %><% }); %>

        do {
            var entity = try <%= _.capitalize(name) %>.find(Node.number(.int(Int(id)!)))!
            <% _.each(attrs, function (attr) { %>
            entity.<%= attr.attrName %> = <%= attr.attrName %><% }); %>
            try entity.save()
            let json = Mapper().toJSON(entity)
            response.status(.OK).send(json: JSON(json))
            next()
        } catch {
            response.status(.internalServerError)
            next()
        }
    }

    private func onDeleteByID(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let id = request.parameters["id"] else {
            Log.warning("Could not parse ID")
            response.status(.badRequest)
            next()
            return
        }

        do {
            let entity = try <%= _.capitalize(name) %>.find(Node.number(.int(Int(id)!)))!
            try entity.delete()
            response.status(.noContent)
            next()
        } catch {
            response.status(.internalServerError)
            next()
        }
    }
}
