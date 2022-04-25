

CLASS Validator

	METHOD New() 	CONSTRUCTOR
	
	METHOD View() 
	METHOD Test() 
	
   
ENDCLASS

METHOD New( o ) CLASS Validator	

RETU SELF

METHOD View( o ) CLASS Validator

	LOCAL oApp := MC_GetApp()

	o:View( 'validator/valid.view' )

	
RETU NIL

METHOD Test( oController ) CLASS Validator

	local hData := oController:PostAll()
	local oV 		
	
	_z( 'PRE-VALIDATED', hData )
	
	DEFINE VALIDATOR oV WITH hData
		PARAMETER 'test_required' 	NAME 'Test Required' ROLES 'required' OF oV	
		PARAMETER 'test_numeric'  	NAME 'Test Numeric'  ROLES 'numeric' FORMATTER 'tonumber' OF oV	
		PARAMETER 'test_string'   	NAME 'Test String'  ROLES 'string' FORMATTER 'upper' OF oV	
		PARAMETER 'test_len'   	NAME 'Test Len'  ROLES 'len:5' OF oV	
		PARAMETER 'test_max'   	NAME 'Test Max'  ROLES 'max:100' OF oV	
		PARAMETER 'test_min'   	NAME 'Test Min'  ROLES 'min:1' OF oV	
		PARAMETER 'test_maxlen'   	NAME 'Test MaxLen'  ROLES 'maxlen:20' OF oV	
		PARAMETER 'test_minlen'   	NAME 'Test MinLen'  ROLES 'minlen:3' OF oV	
		PARAMETER 'test_logic'   	NAME 'Test Logic'  FORmATTER 'tologic' OF oV	
		PARAMETER 'test_binary'   	NAME 'Test Binary' FORmATTER 'tobin' OF oV			
		PARAMETER 'test_date'   	NAME 'Test Binary' FORmATTER 'todate' OF oV	
		PARAMETER 'test_formatter'	NAME 'Test Formatter' ROLES 'numeric|maxlen:5' FORMATTER {|u| MyFormatter(u) } OF oV	
		PARAMETER 'test_mail'		NAME 'Test Mail' ROLES 'ismail' FORMATTER 'lower' OF oV	
	RUN VALIDATOR oV 
	
	if oV:lError
		oController:View( 'error.view', 200, oV:ErrorString() )				
		retu 
	endif			
	
	_z( 'POST-VALIDATED', hData  )	

retu nil 



function _z( cTitle, u )

	? '<b><u>' + cTitle + '</u></b><br>' 
	_w( u )
	
retu nil 


function MyFormatter(u)			

retu 'PY-' + StrZero( val(u), 5)
	
	
	
