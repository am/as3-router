//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright (c) 2011 the original author or authors
//
// Permission is hereby granted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// 
////////////////////////////////////////////////////////////////////////////////

package com.complexresponse.routing.rules {
	import com.jeremyruppel.routing.core.IRoute;
	import com.jeremyruppel.routing.core.IRule;
	import com.jeremyruppel.routing.rules.RegExpRule;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.osflash.signals.Signal;

	/**
	 * Class.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Jeremy Ruppel
	 * @since  10.09.2010
	 */
	public class RegExpRuleFixture
	{
		// --------------------------------------
		// PRIVATE VARIABLES
		// --------------------------------------
		private var signal : Signal;

		// --------------------------------------
		// SETUP
		// --------------------------------------
		[Before]
		public function startup() : void {
			signal = new Signal();
		}
		//--------------------------------------
		//  TEST CASES
		//--------------------------------------
		
		//--------------------------------------
		//  TEST CASES
		//--------------------------------------
		
		[Test(description="regexp rule returns its signal type")]
		public function test_regexp_rule_returns_its_signal_type( ) : void
		{
			var rule : IRule = new RegExpRule( /\/test/, signal );
			
			assertThat( rule.signal, equalTo( signal ) );
		}
		
		[Test(description="regexp rule uses pattern passed to match a route")]
		public function test_regexp_rule_uses_pattern_passed_to_match_a_route( ) : void
		{
			var rule : IRule = new RegExpRule( /\/test/, signal );
			
			assertThat( rule.matches( '/test' ), isTrue( ) );
			assertThat( rule.matches( '/test-route' ), isTrue( ) );
			assertThat( rule.matches( '/home' ), isFalse( ) );
		}
		
		[Test(description="regexp rule can use splat operator to match anything")]
		public function test_regexp_rule_can_use_splat_operator_to_match_anything( ) : void
		{
			var rule : IRule = new RegExpRule( /\/pages\/*/, signal );
			
			assertThat( rule.matches( '/pages/' ), isTrue( ) );
			assertThat( rule.matches( '/pages/home' ), isTrue( ) );
		}
		
		[Test(description="regexp rule can use anchors to restrict matching")]
		public function test_regexp_rule_can_use_anchors_to_restrict_matching( ) : void
		{
			var rule : IRule = new RegExpRule( /^\/home$/, signal );
			
			assertThat( rule.matches( '/home' ), isTrue( ) );
			assertThat( rule.matches( '/pages/home' ), isFalse( ) );
			assertThat( rule.matches( '/home/about' ), isFalse( ) );
		}
		
		[Test(description="regexp rule execute returns a route object")]
		public function test_regexp_rule_execute_returns_a_route_object( ) : void
		{
			var rule : IRule = new RegExpRule( /^\/home$/, signal );
			
			assertThat( rule.execute( '/home' ), isA( IRoute ) );
		}
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 * @constructor
		 */
		public function RegExpRuleFixture( )
		{
		}

	}

}
