CLASS TestSet 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Get1()
	
	METHOD Set2()
	METHOD Get2()

ENDCLASS 

METHOD New() CLASS TestSet 


RETU Self 

METHOD Get1( oController ) CLASS TestSet 
	
	mc_set( 'name', 'maria')
	? time()
	? 'name', mc_get( 'name')
	

RETU nil 

METHOD Set2( oController ) CLASS TestSet 
	
	local nstart := seconds()
	mc_set( 'name', 'pepitu')
	? time()
	? 'Seted!'
	
	while seconds() - nstart < 5
	
	end 
	
	? 'name', mc_get( 'name')
	

RETU nil 

METHOD Get2( oController ) CLASS TestSet 

	? time()
		mc_set( 'name', 'maria')
		? 'name', mc_get( 'name')
	

RETU nil 