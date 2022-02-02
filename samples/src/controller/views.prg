CLASS Views 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Show()



ENDCLASS 

METHOD New() CLASS Views 


RETU Self 

METHOD Show( oController ) CLASS Views 

	local cId 		:= oController:Get( 'id' )
	local hData 	:= { 'first' => 'Max', 'last' => 'Headrom', 'zip' => '45004X'}
	local cFile 	:= 'html' + cId + '.view'

	oController:View( cFile, hData )

RETU nil 



