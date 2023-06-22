const std = @import("std");
const Allocator = std.mem.Allocator;
const Map = std.AutoHashMap;
const List = std.ArrayList;

const Builtins = @import("../builtins.zig").Builtins;
const interner = @import("../interner.zig");
const Interned = interner.Interned;
const parser = @import("../parser.zig");
pub const Span = parser.types.Span;
const monotype = @import("monotype.zig");
pub const TypeVar = monotype.TypeVar;
pub const MonoType = monotype.MonoType;

pub const Substitution = struct {
    map: Map(TypeVar, MonoType),
};

pub const EqualConstraint = struct {
    left: MonoType,
    right: MonoType,
};

pub const Constraints = struct {
    equal: List(EqualConstraint),
    next_type_var: u64,
};

pub const Binding = struct {
    type: MonoType,
    global: bool,
    mutable: bool,
};

pub const Scope = Map(Interned, Binding);

pub const Int = struct {
    value: Interned,
    span: Span,
    type: MonoType,
};

pub const Float = struct {
    value: Interned,
    span: Span,
    type: MonoType,
};

pub const Symbol = struct {
    value: Interned,
    span: Span,
    type: MonoType,
    global: bool,
};

pub const Bool = struct {
    value: bool,
    span: Span,
    type: MonoType,
};

pub const String = struct {
    value: Interned,
    span: Span,
    type: MonoType,
};

pub const Define = struct {
    name: Symbol,
    value: *const Expression,
    span: Span,
    mutable: bool,
    type: MonoType,
};

pub const Drop = struct {
    value: *const Expression,
    span: Span,
    type: MonoType,
};

pub const PlusEqual = struct {
    name: Symbol,
    value: *const Expression,
    span: Span,
    type: MonoType,
};

pub const TimesEqual = struct {
    name: Symbol,
    value: *const Expression,
    span: Span,
    type: MonoType,
};

pub const Block = struct {
    expressions: []Expression,
    span: Span,
    type: MonoType,
};

pub const Parameter = struct {
    name: Symbol,
    mutable: bool,
};

pub const Function = struct {
    parameters: []Parameter,
    return_type: MonoType,
    body: Block,
    span: Span,
    type: MonoType,
};

pub const BinaryOp = struct {
    kind: parser.types.BinaryOpKind,
    left: *const Expression,
    right: *const Expression,
    span: Span,
    type: MonoType,
};

pub const Arm = struct {
    condition: Expression,
    then: Block,
};

pub const Branch = struct {
    arms: []Arm,
    else_: Block,
    span: Span,
    type: MonoType,
};

pub const Argument = struct {
    value: Expression,
    mutable: bool,
};

pub const Call = struct {
    function: *const Expression,
    arguments: []Argument,
    span: Span,
    type: MonoType,
};

pub const Intrinsic = struct {
    function: Interned,
    arguments: []Argument,
    span: Span,
    type: MonoType,
};

pub const Group = struct {
    expressions: []Expression,
    span: Span,
    type: MonoType,
};

pub const ForeignImport = struct {
    module: Interned,
    name: Interned,
    span: Span,
    type: MonoType,
};

pub const ForeignExport = struct {
    name: Interned,
    value: *const Expression,
    span: Span,
    type: MonoType,
};

pub const Convert = struct {
    value: *const Expression,
    span: Span,
    type: MonoType,
};

pub const Undefined = struct {
    span: Span,
    type: MonoType,
};

pub const Expression = union(enum) {
    int: Int,
    float: Float,
    symbol: Symbol,
    bool: Bool,
    string: String,
    define: Define,
    drop: Drop,
    plus_equal: PlusEqual,
    times_equal: TimesEqual,
    function: Function,
    binary_op: BinaryOp,
    group: Group,
    block: Block,
    branch: Branch,
    call: Call,
    intrinsic: Intrinsic,
    foreign_import: ForeignImport,
    foreign_export: ForeignExport,
    convert: Convert,
    undefined: Undefined,
};

pub const Untyped = Map(Interned, parser.types.Expression);
pub const Typed = Map(Interned, Expression);

pub const Module = struct {
    allocator: Allocator,
    constraints: *Constraints,
    builtins: Builtins,
    order: []const Interned,
    untyped: Untyped,
    typed: Typed,
    scope: Scope,
    foreign_exports: []const Interned,
};
