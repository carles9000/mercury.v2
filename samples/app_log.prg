//	{% mh_LoadHrb( '..\mercury.hrb' ) %}

function main()

	local oApp
	local o

	?? 'Time:', Time(), '<hr>'
	
	//	http://localhost/z/router/z.prg/customer/get?aaa=pol&bbb=123&ccc
	
	oApp := MC_App():New()
	oApp:Init()
	
_w( 'a', 123, date() )

_l( 'a', 123, date() )

/*	
try
	  _d( oApp )
catch o 
	? 'Error'
end 
*/


retu nil
