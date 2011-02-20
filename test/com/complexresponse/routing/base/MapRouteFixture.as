//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright (c) 2011 the original author or authors
//
// Permission is hereby granted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// 
////////////////////////////////////////////////////////////////////////////////

package com.complexresponse.routing.base {
	import com.jeremyruppel.routing.base.Router;
	import com.jeremyruppel.routing.core.IRouter;
	import com.jeremyruppel.routing.routes.RegExpRoute;
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
	public class MapRouteFixture
	{
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var router : IRouter;
		private var signal : Signal;
		
		//--------------------------------------
		//  SETUP
		//--------------------------------------
		
		[Before]
		public function setup( ) : void
		{
			router = new Router( );
			signal = new Signal();
		}
		
		//--------------------------------------
		//  TEST CASES
		//--------------------------------------
	
		[Test(description="map route matches a string route")]
		public function test_map_route_matches_a_string_route( ) : void
		{
			router.mapRoute( '/home',signal );
			
			assertThat( router.hasRoute( '/home' ), isTrue( ) );
		}
		
		[Test(description="map route matches a string route exactly")]
		public function test_map_route_matches_a_string_route_exactly( ) : void
		{
			router.mapRoute( '/home',signal );
			
			assertThat( router.hasRoute( '/homeopathy' ), isFalse( ) );
			assertThat( router.hasRoute( '/home/page' ), isFalse( ) );
			assertThat( router.hasRoute( '/site/home' ), isFalse( ) );
		}
		
		[Test(description="map route matches a string route with query params afterwards")]
		public function test_map_route_matches_a_string_route_with_query_params_afterwards( ) : void
		{
			router.mapRoute( '/home',signal );
			
			assertThat( router.hasRoute( '/home?hello=tests' ), isTrue( ) );
		}
		
		[Test(async,description="map route maps an signal to a string route")]
		public function test_map_route_maps_an_signal_to_a_string_route( ) : void
		{
			proceedOnSignal(this, signal, 500);
			
			router.mapRoute( '/home', signal );
			
			router.route( '/home' );
		}
		
		[Test(async,description="map route provides a route signal to handler with accurate information about route")]
		public function test_map_route_provides_a_route_signal_to_handler_with_accurate_information_about_route( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).value, equalTo( '/home' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/home',signal );
			
			router.route( '/home' );
		}
		
		[Test(async,description="map route provides a route signal to handler with accurate capture information")]
		public function test_map_route_provides_a_route_signal_to_handler_with_accurate_capture_information( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/:user',signal );
			
			router.route( '/users/jbone' );
		}
		
		[Test(async,description='map route provides a route signal to handler with accurate splat information')]
		public function test_map_route_provides_a_route_signal_to_handler_with_accurate_splat_information( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'username' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/*/profile',signal );
			
			router.route( '/username/profile' );
		}
		
		[Test(async,description="matches route with query string after it")]
		public function test_matches_route_with_query_string_after_it( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/:user',signal );
			
			router.route( '/users/jbone?hello=tests' );
		}
		
		[Test(async,description="matches one query string parameter after route")]
		public function test_matches_one_query_string_parameter_after_route( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'hello' ), equalTo( 'tests' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/:user',signal );
			
			router.route( '/users/jbone?hello=tests' );
		}
		
		[Test(async,description="matches two query string parameters after route")]
		public function test_matches_two_query_string_parameters_after_route( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'hello' ), equalTo( 'tests' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'are' ), equalTo( 'awesome' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/:user',signal );
			
			router.route( '/users/jbone?hello=tests&are=awesome' );
		}
		
		[Test(async,description="matches one query string parameter after route with splat")]
		public function test_matches_one_query_string_parameter_after_route_with_splat( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'hello' ), equalTo( 'tests' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/*',signal );
			
			router.route( '/users/jbone?hello=tests' );
		}
		
		[Test(async,description="matches two query string parameters after route with splat")]
		public function test_matches_two_query_string_parameters_after_route_with_splat( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'hello' ), equalTo( 'tests' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'are' ), equalTo( 'awesome' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/*',signal );
			
			router.route( '/users/jbone?hello=tests&are=awesome' );
		}
		
		[Test(async,description="matches mixed named route section before splat")]
		public function test_matches_mixed_named_route_section_before_splat( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 1 ], equalTo( 'about' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/:user/*',signal );
			
			router.route( '/users/jbone/about' );
		}
		
		[Test(async,description="matches mixed splat before named route section")]
		public function test_matches_mixed_splat_before_named_route_section( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'about' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 1 ], equalTo( 'jbone' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/*/:user',signal );
			
			router.route( '/users/about/jbone' );
		}
		
		[Test(async,description="matches mixed named route section before splat with one query param")]
		public function test_matches_mixed_named_route_section_before_splat_with_one_query_param( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'page' ), equalTo( '4' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 1 ], equalTo( 'about' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/:user/*',signal );
			
			router.route( '/users/jbone/about?page=4' );
		}
		
		[Test(async,description="matches mixed named route section before splat with two query params")]
		public function test_matches_mixed_named_route_section_before_splat_with_two_query_params( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'page' ), equalTo( '4' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'hello' ), equalTo( 'tests' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 1 ], equalTo( 'about' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/:user/*',signal );
			
			router.route( '/users/jbone/about?page=4&hello=tests' );
		}
		
		[Test(async,description="matches mixed splat before named route section with one query param")]
		public function test_matches_mixed_splat_before_named_route_section_with_one_query_param( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'page' ), equalTo( '4' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'about' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 1 ], equalTo( 'jbone' ) );
			};
			
			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/*/:user',signal );
			
			router.route( '/users/about/jbone?page=4' );
		}
		
		[Test(async,description="matches mixed splat before named route section with two query params")]
		public function test_matches_mixed_splat_before_named_route_section_with_two_query_params( ) : void
		{
			var handler : Function = function(event : SignalAsyncEvent, data : Object) : void {
				data;
				assertThat( RegExpRoute(event.args[0]).params( 'user' ), equalTo( 'jbone' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'page' ), equalTo( '4' ) );
				assertThat( RegExpRoute(event.args[0]).params( 'hello' ), equalTo( 'tests' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 0 ], equalTo( 'about' ) );
				assertThat( RegExpRoute(event.args[0]).captures[ 1 ], equalTo( 'jbone' ) );
			};

			handleSignal(this, signal, handler, 500);
			
			router.mapRoute( '/users/*/:user',signal );
			
			router.route( '/users/about/jbone?page=4&hello=tests' );
		}
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 * @constructor
		 */
		public function MapRouteFixture( )
		{
		}
	
	}

}
