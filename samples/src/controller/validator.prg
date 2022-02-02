CLASS Validator

	METHOD New() 	CONSTRUCTOR
	
	METHOD View() 
//	METHOD Run()		
   
ENDCLASS

METHOD New( o ) CLASS Validator	

RETU SELF

METHOD View( o ) CLASS Validator

	LOCAL oApp := MC_GetApp()
	
	? oApp:cApp_Path 
	? oApp:cPathController
	? oApp:cPathView
	
	//? o:View( 'xxx.view' )
	? o:View( 'user.view' )

	
RETU NIL


/*
METHOD Run( o ) CLASS Validator
	
	LOCAL oValidator := TValidator():New()
	LOCAL hRoles     := {=>}	
	
		hRoles[ 'name' ] := 'required|string|maxlen:5'
		hRoles[ 'age'  ] := 'required|numeric'

		IF ! oValidator:Run( hRoles )
			o:View( 'test_validator_run.view', oValidator:ErrorMessages() )			
			RETU NIL
		endif		


	o:View( 'test_validator_run.view' )
	
RETU NIL
*/
