// AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2011 the original author or authors
//
// Permission is hereby granted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
//
// // // //////////////////////////////////////////////////////////////////////////
package com.complexresponse.routing.base {
	import com.jeremyruppel.routing.base.Router;
	import com.jeremyruppel.routing.core.IRouter;
	import com.jeremyruppel.routing.routes.HashRoute;
	import com.jeremyruppel.routing.utils.query;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
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
	public class MapQueryFixture {
		// --------------------------------------
		// PRIVATE VARIABLES
		// --------------------------------------
		private var router : IRouter;
		private var signal : Signal;

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
		[Test(description="map query matches an object route")]
		public function test_map_query_matches_an_object_route() : void {
			router.mapQuery({page:'home'}, signal);

			assertThat(router.hasRoute(query({page:'home'})), isTrue());
		}

		[Test(description="map query can match an object with multiple fields")]
		public function test_map_query_can_match_an_object_with_multiple_fields() : void {
			router.mapQuery({page:'home', view:'main'}, signal);

			assertThat(router.hasRoute(query({page:'home', view:'main'})), isTrue());
		}

		[Test(description="map query objects can accept patterns as well")]
		public function test_map_query_objects_can_accept_patterns_as_well() : void {
			router.mapQuery({user:/\w+/, view:'main'}, signal);

			assertThat(router.hasRoute(query({view:'main', user:'jbone'})), isTrue());
		}

		[Test(description="map query routes must match all parts of the route object")]
		public function test_map_query_routes_must_match_all_parts_of_the_route_object() : void {
			router.mapQuery({page:'home', view:'main'}, signal);

			assertThat(router.hasRoute(query({view:'main'})), isFalse());
			assertThat(router.hasRoute(query({page:'home'})), isFalse());
		}

		[Test(description="map query routes may contain more information than the route object needs")]
		public function test_map_query_routes_may_contain_more_information_than_the_route_object_needs() : void {
			router.mapQuery({page:'home', view:'main'}, signal);

			assertThat(router.hasRoute(query({view:'main', extra:'awesome', page:'home'})), isTrue());
		}

		[Test(async,description="map query maps an signal to an object route")]
		public function test_map_query_maps_an_signal_to_an_object_route() : void {
			proceedOnSignal(this, signal, 500);

			router.mapQuery({page:'home'}, signal);

			router.route(query({page:'home'}));
		}

		[Test(async,description="map query provides a route signal to handler with accurate information about route")]
		public function test_map_query_provides_a_route_signal_to_handler_with_accurate_information_about_route() : void {
			var handler : Function = function(signal : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat(HashRoute(signal.args[0]).value, equalTo('?page=home'));
			};

			handleSignal(this, signal, handler, 500);
			router.mapQuery( { page : 'home' }, signal );
			router.route('?page=home');
		}

		[Test(async,description="map query provides a route signal to handler with accurate parameter information")]
		public function test_map_query_provides_a_route_signal_to_handler_with_accurate_parameter_information() : void {
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat(HashRoute(event.args[0]).params('user'), equalTo('jbone'));
			};

			handleSignal(this, signal, handler, 500);
			router.mapQuery({page:'home', user:/\w+/}, signal);
			router.route(query({page:'home', user:'jbone'}));
		}

		// --------------------------------------
		// CONSTRUCTOR
		// --------------------------------------
		/**
		 * @constructor
		 */
		public function MapQueryFixture() {
		}
	}
}
