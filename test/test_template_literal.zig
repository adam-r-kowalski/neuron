const std = @import("std");
const zap = @import("zap");

test "tokenize template literal" {
    const allocator = std.testing.allocator;
    const source = "html`<h1>Hello World!</h1>`";
    const actual = try zap.testing.tokenize(allocator, source);
    defer allocator.free(actual);
    const expected =
        \\(symbol html)
        \\(template_literal `<h1>Hello World!</h1>`)
    ;
    try std.testing.expectEqualStrings(expected, actual);
}

test "tokenize template literal with interpolation" {
    const allocator = std.testing.allocator;
    const source = "html`<h1>Hello ${name}!</h1>`";
    const actual = try zap.testing.tokenize(allocator, source);
    defer allocator.free(actual);
    const expected =
        \\(symbol html)
        \\(template_literal_begin `<h1>Hello `)
        \\(symbol name)
        \\(template_literal_end `!</h1>`)
    ;
    try std.testing.expectEqualStrings(expected, actual);
}

test "tokenize template literal with two interpolations" {
    const allocator = std.testing.allocator;
    const source = "html`<h1>${x} + ${y} == ${x + y}</h1>`";
    const actual = try zap.testing.tokenize(allocator, source);
    defer allocator.free(actual);
    const expected =
        \\(symbol html)
        \\(template_literal_begin `<h1>`)
        \\(symbol x)
        \\(template_literal_middle ` + `)
        \\(symbol y)
        \\(template_literal_middle ` == `)
        \\(symbol x)
        \\(operator +)
        \\(symbol y)
        \\(template_literal_end `</h1>`)
    ;
    try std.testing.expectEqualStrings(expected, actual);
}
