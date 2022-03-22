function main( oController )	

	AUTENTICATE CONTROLLER oController

	?? time(), '<hr>'
	_w( oController:oMiddleware:GetData() )
	
	
	? '<hr>'
	? "If you can try to delete cookie and refresh screen, you can't access to ::Info() method."
	

retu nil 