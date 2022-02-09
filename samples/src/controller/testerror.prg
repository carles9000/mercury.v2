CLASS TestError 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Info()
	METHOD Crash()

ENDCLASS 

METHOD New() CLASS TestError 


RETU Self 

METHOD Info( oApp, hParam ) CLASS TestError 


	_w( oApp )
	_w( hParam )
	

RETU nil 

// 	Test errors

METHOD Crash( oApp, hParam ) CLASS TestError 

	_w( 'METHOD Crash()' )
	
	? Test1()		//	from loadfile_a.prg
	
	//	Error Test
	
	::XXX()		
	//:XXX()		
	//A+5
	//xxx()				//	Aquesta no chuta
	//Substr('a')	
	//max( 5,'a')
	//use test	
	//7/0
	
RETU nil 

{% mh_LoadFile( "/src/controller/loadfile_a.prg" ) %}
{% mh_LoadFile( "/src/controller/loadfile_b.prg" ) %}
