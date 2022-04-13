CLASS Route	

	METHOD New() 	CONSTRUCTOR
	
	METHOD Test1() 
	METHOD Test2() 
	METHOD Test3() 		
   
ENDCLASS

METHOD New( o ) CLASS Route	

RETU SELF

METHOD Test1( o ) CLASS Route	

	?? '<h3>Test 1. No parameters</h3><hr>'
	
	? "<code>DEFINE ROUTE 'rt.1'	URL 'get' CONTROLLER 'test1@route.prg' OF oApp</code>"	

RETU NIL 

METHOD Test2( o ) CLASS Route	

	?? '<h3>Test 2. Url Friendly. Required Parameter</h3><hr>'
	
	? "<code>DEFINE ROUTE 'rt.2'	URL 'get/name/(id)' CONTROLLER 'test2@route.prg' OF oApp</code>"	
	
	? '<br><hr><b>Parameters</b><br>'
	
	? o:GetAll()

RETU NIL 

METHOD Test3( o ) CLASS Route	

	?? '<h3>Test 3. Url Friendly. Required and Optional parameters</h3><hr>'
	
	? "<code>DEFINE ROUTE 'rt.3' 	URL 'user/(id)/info/[what]' CONTROLLER 'test3@route.prg' OF oApp</code>"	
	
	? '<br><hr><b>Parameters</b><br>'
	
	? o:GetAll()

RETU NIL 


/*
METHOD test1( o ) CLASS Route	

	?  "MC_Route( 'r9', { '720' } )"		, MC_Route( 'r9', { '720' } )
	?  "MC_Route( 'z0', { '720' } )"		, MC_Route( 'z0', { '720' } )
	?  "MC_Route( 'z1', { '720' } )"		, MC_Route( 'z1', { '720' } )
	?  "MC_Route( 'z1', { '720', 'NY' } )"	, MC_Route( 'z1', { '720', 'NY' } )
	?  "MC_Route( 'z2', { '720', 'NY' } )"	, MC_Route( 'z2', { '720', 'NY' } )
	?  "MC_Route( 'z2', { 720, 'NY' } )"	, MC_Route( 'z2', { 720, 'NY' } )
	?  "MC_Route( 'z2', {} )"				, MC_Route( 'z2', {} )
	?  "MC_Route( 'z2' )"					, MC_Route( 'z2' )
	?  "MC_Route( 'xxx' )"					, MC_Route( 'xxx' )
	
RETU NIL
*/
