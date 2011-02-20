//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright (c) 2011 the original author or authors
//
// Permission is hereby granted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// 
////////////////////////////////////////////////////////////////////////////////

package com.jeremyruppel.routing.rules {
	import com.jeremyruppel.routing.core.IRoute;
	import com.jeremyruppel.routing.core.IRule;
	import com.jeremyruppel.routing.routes.RegExpRoute;
	import com.jeremyruppel.routing.utils.parse;

	import org.osflash.signals.ISignal;

	/**
	 * A routing rule based on a regular expression pattern.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Jeremy Ruppel
	 * @since  10.09.2010
	 */
	public class RegExpRule implements IRule
	{
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 * @constructor
		 */
		public function RegExpRule( pattern : RegExp, signal : ISignal )
		{
			_pattern = pattern;
			_signal = signal;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
	
		/**
		 * @private
		 */
		private var _pattern : RegExp;
		
		/**
		 * @private
		 */
		private var _signal : ISignal;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get signal( ) : ISignal
		{
			return _signal;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/**
		 * @inheritDoc
		 * @param route String
		 * @return Boolean 
		 */
		public function matches( route : String ) : Boolean
		{
			return _pattern.test( route.split( '?' ).shift( ) );
		}
		
		/**
		 * @inheritDoc
		 * @param route String
		 * @return IRoute
		 */
		public function execute( route : String ) : IRoute
		{
			return new RegExpRoute( _pattern.exec( route.split( '?' ).shift( ) ), parse( route ) );
		}
	
	}

}
