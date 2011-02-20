// AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2011 the original author or authors
//
// Permission is hereby granted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
//
// // // // ////////////////////////////////////////////////////////////////////////
package com.jeremyruppel.routing.base {
	import com.jeremyruppel.routing.core.IRoute;
	import com.jeremyruppel.routing.core.IRouter;
	import com.jeremyruppel.routing.core.IRule;
	import com.jeremyruppel.routing.rules.HashRule;
	import com.jeremyruppel.routing.rules.RegExpRule;
	import com.jeremyruppel.routing.utils.bookend;
	import com.jeremyruppel.routing.utils.capture;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * Fork of AS3-Router (Jeremy Ruppel) to using signals insted of events.
	 * Basic router that will map routes to events and dispatch them.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Jeremy Ruppel
	 * @since  08.09.2010
	 * @author am
	 */
	public class Router implements IRouter {
		// --------------------------------------
		// CONSTRUCTOR
		// --------------------------------------
		/**
		 * @constructor
		 */
		public function Router() {
		}

		// --------------------------------------
		// PRIVATE VARIABLES
		// --------------------------------------
		/**
		 * @private
		 */
		private var _rules : Array;
		/**
		 * @private
		 */
		private var _unrouted : ISignal = new Signal(IRoute);

		// --------------------------------------
		// GETTER/SETTERS
		// --------------------------------------
		/**
		 * @private
		 */
		public function get rules() : Array {
			return _rules || ( _rules = new Array() );
		}

		/**
		 * @inheritDoc
		 */
		public function get unrouted() : ISignal {
			return _unrouted;
		}

		// --------------------------------------
		// PUBLIC METHODS
		// --------------------------------------
		/**
		 * @inheritDoc
		 * @param route String
		 * @param eventType String
		 */
		public function mapRoute(route : String, signal : ISignal) : void {
			mapPattern(new RegExp(bookend(capture(route))), signal);
		}

		/**
		 * @inheritDoc
		 * @param pattern RegExp
		 * @param eventType String
		 */
		public function mapPattern(pattern : RegExp, signal : ISignal) : void {
			rules.push(new RegExpRule(pattern, signal));
		}

		/**
		 * @inheritDoc
		 * @param hash Object
		 * @param eventType String
		 */
		public function mapQuery(hash : Object, signal : ISignal) : void {
			rules.push(new HashRule(hash, signal));
		}

		/**
		 * @inheritDoc
		 * @param route String
		 * @return Boolean 
		 */
		public function hasRoute(route : String) : Boolean {
			for each ( var rule : IRule in rules ) {
				if ( rule.matches(route) ) {
					return true;
				}
			}

			return false;
		}

		/**
		 * @inheritDoc
		 * @param route String
		 */
		public function route(route : String) : void {
			for each ( var rule : IRule in rules ) {
				if ( rule.matches(route) ) {
					Signal(rule.signal).dispatch(rule.execute(route));
					return;
				}
			}
			Signal(unrouted).dispatch(new Route(route));
		}
	}
}
