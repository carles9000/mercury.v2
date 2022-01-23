#include 'mercury.ch' 

CLASS MC_Request 

	DATA oApp 

	
	METHOD New( oApp )		CONSTRUCTOR

	

ENDCLASS 

//	------------------------------------------------------------	//

METHOD New( oApp ) CLASS MC_Request 

	::oApp := oApp 
	
retu Self 

//	------------------------------------------------------------	//
