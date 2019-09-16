//
//  AtomicSpec.swift
//  ReactiveSwift
//
//  Created by Justin Spahr-Summers on 2014-07-13.
//  Copyright (c) 2014 GitHub. All rights reserved.
//

import Nimble
import Quick
import ReactiveSwift

class AtomicSpec: QuickSpec {
	override func spec() {
		var atomic: Atomic<Int>!

		beforeEach {
			atomic = Atomic(1)
		}

		it("should read and write the value directly") {
			expect(atomic.value) == 1

			atomic.value = 2
			expect(atomic.value) == 2
		}

		it("should swap the value atomically") {
			expect(atomic.swap(2)) == 1
			expect(atomic.value) == 2
		}

		it("should modify the value atomically") {
			atomic.modify { $0 += 1 }
			expect(atomic.value) == 2
		}

		it("should perform an action with the value") {
			let result: Bool = atomic.withValue { $0 == 1 }
			expect(result) == true
			expect(atomic.value) == 1
		}

		it("should work as a property wrapper") {
			struct Foo {
				@Atomic
				static fileprivate(set) var bar: [Int] = []
			}
			Foo.bar.append(1)
			Foo.$bar.withValue { $0 + [2] }
			expect(Foo.bar) == [1]
		}
	}
}
