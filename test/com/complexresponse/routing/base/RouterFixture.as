// AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2011 the original author or authors
//
// Permission is hereby granted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
//
// //////////////////////////////////////////////////////////////////////////////
package com.complexresponse.routing.base {
	import com.jeremyruppel.routing.base.Route;
	import com.jeremyruppel.routing.base.Router;
	import com.jeremyruppel.routing.core.IRouter;
	import com.jeremyruppel.routing.routes.RegExpRoute;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.failOnSignal;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;


	/**
	 * Class.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Jeremy Ruppel
	 * @since  27.09.2010
	 */
	public class RouterFixture {
		// --------------------------------------
		// TEST CASES
		// --------------------------------------
		[Test(description="router provides its own signal dispatcher if none is supplied")]
		public function test_router_provides_its_own_signal_dispatcher_if_none_is_supplied() : void {
			var router : IRouter = new Router();

			assertThat(router.unrouted, isA(ISignal));

//			assertThat(router.unrouted, sameInstance(router));
		}

		[Test(async,description="router can dispatch signals off of itself if no signal dispatcher is supplied")]
		public function test_router_can_dispatch_signals_off_of_itself_if_no_signal_dispatcher_is_supplied() : void {
			var router : IRouter = new Router();
			var signal : ISignal = new Signal();

			proceedOnSignal(this, signal, 500);

			router.mapRoute('/home', signal);

			router.route('/home');
		}

		[Test(async,description="router matches routes in order of mapping")]
		public function test_router_matches_routes_in_order_of_mapping() : void {
			var router : IRouter = new Router();
			var firstSignal : ISignal = new Signal();
			var secondSignal : ISignal = new Signal();
			var thirdSignal : ISignal = new Signal();

			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				assertThat(data, equalTo(secondSignal));
				assertThat(RegExpRoute(event.args[0]).params('user'), equalTo('jbone'));
			};
			
			handleSignal(this, secondSignal, handler, 500, secondSignal);

			router.mapRoute('/users/quality-assurance',firstSignal);
			router.mapRoute('/users/:user', secondSignal);
			router.mapRoute('/about-us', thirdSignal);

			router.route('/users/jbone');
		}
		
		[Test(async,description="router dispatches not found signal if no routes can be matched")]
		public function test_router_dispatches_not_found_signal_if_no_routes_can_be_matched() : void {
			var router : IRouter = new Router();
			var signal : ISignal = new Signal();

			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat(Route(event.args[0]).value, equalTo('/pages/contact'));
			};

			handleSignal(this, router.unrouted, handler, 500);

			router.mapRoute('/pages/home', signal);

			router.route('/pages/contact');
		}
		
		[Test(async,description="router does not dispatch not found signal if a route is matched")]
		public function test_router_does_not_dispatch_not_found_signal_if_a_route_is_matched() : void {
			var router : IRouter = new Router();
			var signal : ISignal = new Signal();

			failOnSignal(this, router.unrouted, 500);
			
			router.mapRoute('/pages/home', signal);

			router.route('/pages/home');
		}
		
		[Test(async,description="router will only match one route per route request")]
		public function test_router_will_only_match_one_route_per_route_request() : void {
			var router : IRouter = new Router();
			var firstSignal : ISignal = new Signal();
			var secondSignal : ISignal = new Signal();

			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat(RegExpRoute(event.args[0]).value, equalTo('/pages/home'));
			};
			
			failOnSignal(this, secondSignal, 500);

			router.mapRoute('/pages/home', firstSignal);
			router.mapRoute('/pages/home', secondSignal);

			router.route('/pages/home');
		}

		// --------------------------------------
		// CONSTRUCTOR
		// --------------------------------------
		/**
		 * @constructor
		 */
		public function RouterFixture() {
		}
	}
}