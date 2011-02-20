AS3 Router - Signals
====================

This is s fork from **as3-router** to make it use signals instead of events. 
Check "Robert Penner":http://robertpenner.com/ 's "as3-signals":http://github.com/robertpenner/as3-signals.

**as3-router** is a simple hash and query string router for ActionScript 3
that maps route strings to events. This project was inspired by the simplicity
of routing by frameworks like [Sinatra][Sinatra] and [Backbone][Backbone].

The router does not hook into any specific deep-linking solution (though if
you're looking for one, I'd strongly recommend [SWFAddress][SWFAddress]).
It simply takes a string route and interprets it into an event, including
route information and parameters.

Also, it should be noted that the router works extremely well with [RobotLegs][RobotLegs],
though there are absolutely no dependencies on it.

Usage Overview
--------------

A router can be instantiated stand-alone and can route events through its
`eventDispatcher` accessor.

	var router : IRouter = new Router( );
	var signal : ISignal = Signal( );
	
	router.mapRoute( '/hello/:name', signal );
	
	signal.add( function( route : IRoute ) : void
	{
		route.value; // => '/hello/awesome'
		
		route.params( 'name' ); // => awesome
	} );
	
	// later on...
	router.route( '/hello/awesome' );


Route Mappings
--------------

The base Router implementation can map string routes, regex routes, and query string routes
(represented as objects). The most typical and convenient use case should be to map string
routes, as they are internally converted to regex patterns with some common pattern conventions
that should be familiar to anyone who has experience routing with Sinatra or Backbone.

`mapRoute` can accept named parameters denoted by a colon. For example:

	router.mapRoute( '/hello/:name', helloSignal );

will match "/hello/world", "hello/friend", "hello/no-wait-actually-goodbye", etc. The value of 
a named parameter can be retrieved from the `route` object of the route event dispatched
when this route is matched, like:

	route.params( 'name' ); // => 'no-wait-actually-goodbye'

Multiple parameters can be declared and will each be matched by name:

	router.mapRoute( '/:section/:page', pageSignal );
	
	router.hasRoute( '/company/manifesto' ); // => true
	
	// and for the event's route...
	route.params( 'section' ); // => 'company'
	route.params( 'page' ); // => 'manifesto'

String routes can also contain splats that will be available as unnamed captures populated in
the route object's `captures` array:

	router.mapRoute( '/*/profile', profileSignal );
	
	router.hasRoute( '/username/profile' ); // => true
	
	router.hasRoute( '/username/contact' ); // => false
	
	// and for the signal's route...
	route.captures[ 0 ]; // => 'username'

Routes also receive query parameters in their params object. This can be useful for
tweaking behavior of routes:

	router.mapRoute( '/blog', blogSignal );
	
	router.route( '/blog?page=4' );
	
	// and for the signal's route...
	route.params( 'page' ); // => '4'

`mapQuery` can match query-string-style routes if you need them. Because query strings are
unordered key value pairs, they are matched as simple objects, like:

	router.mapQuery( { page : 'home', action : 'whatever' }, homeSignal );
	
	router.route( '?action=whatever&page=home' );
	
	// and for the signal's route...
	route.params( 'action' ); // => 'whatever'
	route.params( 'page' ); // => 'home'

Unmapped Routes
---------------

If no route is matched through a call to `route`, a `RouteEvent.NOT_FOUND` event will
be dispatched from the router's eventDispatcher.

[Sinatra]: http://www.sinatrarb.com/ "Sinatra"
[Backbone]: http://documentcloud.github.com/backbone/ "Backbone.js"
[SWFAddress]: http://www.asual.com/swfaddress/ "SWFAddress"
[RobotLegs]: https://github.com/robotlegs/robotlegs-framework "RobotLegs"
[as3-signals]: http://github.com/robertpenner/as3-signals "As3-signals"