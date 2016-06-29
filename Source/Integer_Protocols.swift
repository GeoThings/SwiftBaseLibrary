﻿
/* Numbers */

//public typealias Equatable = IEquatable
public protocol Equatable { // NE19 The public type "IEquatable" has a duplicate with the same short name, which is not allowed on Cocoa
	func ==(lhs: Self, rhs: Self) -> Bool
}

//public typealias Comparable = IComparable
public protocol Comparable : Equatable {
	func <(lhs: Self, rhs: Self) -> Bool
	func <=(lhs: Self, rhs: Self) -> Bool
	func >=(lhs: Self, rhs: Self) -> Bool
	func >(lhs: Self, rhs: Self) -> Bool
}

public typealias IIncrementable = Incrementable
public protocol Incrementable : Equatable {
	func successor() -> Self
}

// CAUTION: Magic type name. 
// The compiler will allow any value implementing Swift.IBooleanType type to be used as boolean
public typealias IBooleanType = BooleanType
public protocol BooleanType {
	var boolValue: Bool { get }
}

public protocol IntegerArithmeticType : Comparable {
	//class func addWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool) //71481: Silver: can't use Self in tuple on static funcs i(in public protocols?)
	//class func subtractWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func multiplyWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func divideWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func remainderWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)

	func +(lhs: Self, rhs: Self) -> Self
	func -(lhs: Self, rhs: Self) -> Self
	func *(lhs: Self, rhs: Self) -> Self
	func /(lhs: Self, rhs: Self) -> Self
	func %(lhs: Self, rhs: Self) -> Self
	func toIntMax() -> IntMax
}

public protocol BitwiseOperationsType {
	//func &(_: Self, _: Self) -> Self //69825: Silver: two probs with operators in public protocols
	func |(_: Self, _: Self) -> Self
	func ^(_: Self, _: Self) -> Self
	prefix func ~(_: Self) -> Self

	/// The identity value for "|" and "^", and the fixed point for "&".
	///
	/// ::
	///
	///   x | allZeros == x
	///   x ^ allZeros == x
	///   x & allZeros == allZeros
	///   x & ~allZeros == x
	///
	//static/*class*/ var allZeros: Self { get }
}

public typealias SignedNumberType = ISignedNumberType
public protocol ISignedNumberType : Comparable, IntegerLiteralConvertible {
	@warn_unused_result prefix func -(_ x: Self) -> Self
	@warn_unused_result func -(_ lhs: Self, _ rhs: Self) -> Self
}

public protocol AbsoluteValuable : SignedNumberType {
	@warn_unused_result static func abs(_ x: Self) -> Self
}

public typealias SignedIntegerType = ISignedIntegerType
public protocol ISignedIntegerType {
	init(_ value: IntMax)
	@warn_unused_result func toIntMax() -> IntMax
}

public typealias UnsignedIntegerType = IUnsignedIntegerType
public protocol IUnsignedIntegerType {
	init(_ value: UIntMax)
	@warn_unused_result func toUIntMax() -> UIntMax
}
