enum <%= _.capitalize(attr.attrName) %>Enum : String {
    <% _.each(attr.enumValues, function (value) { %>
    case <%= value %> = "<%= value %>"<% }); %>
}
