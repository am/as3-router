// AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2011 the original author or authors
//
// Permission is hereby granted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
//
// // ////////////////////////////////////////////////////////////////////////////
package com.complexresponse.routing.base {
	import com.jeremyruppel.routing.base.Router;
	import com.jeremyruppel.routing.core.IRouter;
	import com.jeremyruppel.routing.routes.RegExpRoute;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;
	import org.osflash.signals.utils.proceedOnSignal;


	/**
	 * Class.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Jeremy Ruppel
	 * @since  10.09.2010
	 */
	public class MapPatternFixture {
		// --------------------------------------
		// PRIVATE VARIABLES
		// --------------------------------------
		private var router : IRouter;
		private var signal : ISignal;

		// --------------------------------------
		// SETUP
		// --------------------------------------
		[Before]
		public function startup() : void {
			router = new Router();
			signal = new Signal();
		}

		// --------------------------------------
		// TEST CASES
		// --------------------------------------
		[Test(description="map pattern matches routes to a regexp")]
		public function test_map_pattern_matches_routes_to_a_regexp() : void {
			router.mapPattern(/^\/home$/, signal);

			assertThat(router.hasRoute('/home'), isTrue());
		}

		[Test(description="map pattern matches route with query string afterwards")]
		public function test_map_pattern_matches_route_with_query_string_afterwards() : void {
			router.mapPattern(/^\/home$/, signal);

			assertThat(router.hasRoute('/home?hello=tests'), isTrue());
		}

		[Test(description="map pattern can match parts of a route")]
		public function test_map_pattern_can_match_parts_of_a_route() : void {
			router.mapPattern(/^\/home/, signal);

			assertThat(router.hasRoute('/home'), isTrue());
			assertThat(router.hasRoute('/homeopathy'), isTrue());
		}

		[Test(description="map pattern can match parts of a route with query string afterwards")]
		public function test_map_pattern_can_match_parts_of_a_route_with_query_string_afterwards() : void {
			router.mapPattern(/^\/home/, signal);

			assertThat(router.hasRoute('/home?hello=tests'), isTrue());
			assertThat(router.hasRoute('/homeopathy?hello=tests'), isTrue());
		}

		[Test(description="map pattern can match anything with the splat operator")]
		public function test_map_pattern_can_match_anything_with_the_splat_operator() : void {
			 router.mapPattern( /^\/*/, signal );

			assertThat(router.hasRoute('/home'), isTrue());
			assertThat(router.hasRoute('/about-us'), isTrue());
			assertThat(router.hasRoute('/ridiculous/subpage/1'), isTrue());
		}

		[Test(async,description="map pattern maps an signal to a route pattern")]
		public function test_map_pattern_maps_an_signal_to_a_route_pattern() : void {
			proceedOnSignal(this, signal, 500);
			router.mapPattern(/^\/home/, signal);
			router.route('/home');
		}

		[Test(async,description="map pattern provides a route signal to handler with accurate information about route")]
		public function test_map_pattern_provides_a_route_event_to_handler_with_accurate_information_about_route() : void {
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat(RegExpRoute(event.args[0]).value, equalTo('/home'));
			};

			handleSignal(this, signal, handler, 500);
			router.mapPattern(/^\/home$/, signal);
			router.route('/home');
		}

		// --------------------------------------
		// CONSTRUCTOR
		// --------------------------------------
		/**
		 * @constructor
		 */
		public function MapPatternFixture() {
		}
	}
}
