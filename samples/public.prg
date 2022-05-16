//	{% mh_LoadHrb( '..\lib\mercury.hrb' ) %}
	
//	--------------------------------------------------------------------------------------
//	Examples: your <url> localhost/test
//	=====================================================
//	empty 					=> <url>/
//	route					=> <url>/customer 
//	route (breadcrumb)	=> <url>/customer/list
// 	parameters				=> <url>/?age=1&level=0
//	route + parameters  	=> <url>/customer?age=1&level=0
//
//	http://localhost/z/router/z.prg/customer/get?aaa=pol&bbb=123&ccc
//
//	url no amigable: http://impressas.es/empresa.php?empresa=embutidos-la-serena
//	url amigable: http://impressas.es/empresa/embutidos-la-serena
//
//	--------------------------------------------------------------------------------------

function main()

	local cQuery, cParameteres, cAll 

	?? 'Time:', Time(), '<hr>'
	

	? 'MC_App_Url()' 		, '=>', MC_App_Url()			//	/z/router
	? 'MC_App_Path()' 		, '=>', MC_App_Path()			//	C:/xampp/htdocs/z/router
	
	? 'MC_Script_Url()' 	, '=>', MC_Script_Url()		//	/z/router/z.prg
	? 'MC_Script_Path()' 	, '=>', MC_Script_Path()		//	c:/xampp/htdocs/z/router/z.prg
	
	? 'MC_Uri()' 			, '=>', MC_Uri()				//	/z/router/z.prg/customer/get?aaa=pol&bbb=123&ccc
	? 'MC_Document_Root()' 	, '=>', MC_Document_Root()	//	c:/xampp/htdocs
		
	
	? 'MC_Prg()' 			, '=>', MC_Prg()				//	z.prg
	? 'MC_Method()' 		, '=>', MC_Method()			//	GET, POST, ...
		
	? 'MC_Url_Friendly()'   , '=>', MC_Url_Friendly()		// {"customer", "get"}
	? 'MC_Url_Query()' 		, '=>', MC_Url_Query()		// { 'aaa' => 'pol', 'bbb' => 123, 'ccc' => '' }
	
	//	-----------------------------------------------------------------	//
	
	cQuery 		:= MC_Script_Url() + '?one=first&two=second&three=third'
	cParameters 	:= MC_Script_Url() + '/customer/id/123'
	cAll 			:= MC_Script_Url() + '/customer/id/123?one=first&two=second&three=third'
   
	? '<hr>'
	? 'Query =>' , '<a href="' + cQuery + '" >' + cQuery + '</a>'	
	? 'Parameters =>' , '<a href="' + cParameters + '" >' + cParameters + '</a>'	
	? 'Parameters + Query =>' , '<a href="' + cAll + '" >' + cAll + '</a>'	
	

retu nil
