﻿

public extension UnicodeScalar : Streamable {
	
	public var value: UInt32 { 
		return self as! UInt32 
	}
	
	public func escape(# asASCII: Bool) -> String {
		if asASCII && !isASCII() {
			#if JAVA
			return self.toString()
			#elseif CLR || ISLAND
			return self.ToString()
			#elseif COCOA
			return self.description()
			#endif
		}
		else {
			#if JAVA
			return java.lang.String.format("\\u{%8x}", self as! Int32)
			#elseif CLR || ISLAND
			return /*System.*/String.Format("\\u{{{0:X8}}}", self as! Int32)
			#elseif COCOA
			return Foundation.NSString.stringWithFormat("\\u{%8x}", self as! Int32)
			#endif
		}
	}
	
	public func isASCII() -> Bool {
		return self <= 127
	}
	
	
	public func stringValue() -> String {
		let bytes: Byte[] = [self & 0xff, (self >> 8) & 0xff, (self >> 16) & 0xff, (self >> 24) & 0xff, 0, 0, 0, 0]
		#if JAVA
		return java.lang.String(bytes,"UTF16")
		#elseif CLR
		return System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetString(bytes, 0, 1) // todo check order  
		#elseif ISLAND
		return self.toHexString(length: 6) // UnicodeScalar.ToString() is not supported on Island yet.
		#elseif COCOA
		#hint doesn't seem to work
		return NSString.stringWithCString(bytes as! UnsafePointer<AnsiChar>, encoding:.UTF32LittleEndianStringEncoding)
		#endif
	}
	
	public func writeTo(_ target: OutputStreamType) {
		target.write(stringValue())
	}
	
	#if JAVA
	//workaround for 75341: Silver: Cooper: adding any interface to a struct via extension requires implementing `equals` and `hashCode`.
	func equals(_ arg1: Object!) -> Boolean {
		if let v = arg1 as? UnicodeScalar {
			return v == self
		}
		return false
	}
	
	func hashCode() -> Integer {
		return value
	}
	#endif
}