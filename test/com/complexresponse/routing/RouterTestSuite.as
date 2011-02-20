//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright (c) 2011 the original author or authors
//
// Permission is hereby granted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// 
////////////////////////////////////////////////////////////////////////////////

package com.complexresponse.routing
{
	import com.complexresponse.routing.base.MapPatternFixture;
	import com.complexresponse.routing.base.MapQueryFixture;
	import com.complexresponse.routing.base.MapRouteFixture;
	import com.complexresponse.routing.base.RouteFixture;
	import com.complexresponse.routing.base.RouterFixture;
	import com.complexresponse.routing.routes.HashRouteFixture;
	import com.complexresponse.routing.routes.RegExpRouteFixture;
	import com.complexresponse.routing.rules.HashRuleFixture;
	import com.complexresponse.routing.rules.RegExpRuleFixture;
	import com.complexresponse.routing.utils.BookendFixture;
	import com.complexresponse.routing.utils.CaptureFixture;
	import com.complexresponse.routing.utils.ParseFixture;
	import com.complexresponse.routing.utils.QueryFixture;

	/**
	 * Class.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Jeremy Ruppel
	 * @since  08.09.2010
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class RouterTestSuite
	{
		//--------------------------------------
		//  TEST FIXTURES
		//--------------------------------------
	
		// routing.base               : contains the base classes for the suite
		public var mapPatternFixture  : MapPatternFixture;
		public var mapQueryFixture    : MapQueryFixture;
		public var mapRouteFixure     : MapRouteFixture;
		public var routeFixture       : RouteFixture;
		public var routerFixture      : RouterFixture;
//		
//		// routing.routes             : contains various route types
		public var hashRouteFixture   : HashRouteFixture;
		public var regExpRouteFixture : RegExpRouteFixture;
//		
//		// routing.rules              : contains various route rules to match routes
		public var hashRuleFixture    : HashRuleFixture;
		public var regExpRuleFixture  : RegExpRuleFixture;
//		
//		// routing.utils              : contains helper methods and utilities
		public var bookendFixture     : BookendFixture;
		public var captureFixture     : CaptureFixture;
		public var parseFixture       : ParseFixture;
		public var queryFixture       : QueryFixture;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 * @constructor
		 */
		public function RouterTestSuite( )
		{
		}
	}
}
