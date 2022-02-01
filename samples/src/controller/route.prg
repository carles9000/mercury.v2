CLASS Route

	

	METHOD New() 	CONSTRUCTOR
	
	METHOD test1() 
		
   
ENDCLASS

METHOD New( o ) CLASS Route	

RETU SELF

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
