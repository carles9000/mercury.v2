#ifndef _MERCURY_CH
#define _MERCURY_CH

/*
#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  If( <uVar1> == nil, <uVar1> := <uVal1>, ) ;;
                [ If( <uVarN> == nil, <uVarN> := <uValN>, ); ]
*/				
/*
#xcommand TRY  => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS
*/

#xcommand ? [<explist,...>] => AP_Echo( '<br>' [,<explist>] )
#xcommand ?? [<explist,...>] => AP_Echo( [<explist>] )

#xcommand BLOCKS TO <b> [ PARAMS [<v1>] [,<vn>] ] [ TAGS <t1>,<t2> ];
=> #pragma __cstream | <b>+=mh_ReplaceBlocks( %s, "{{", "}}" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] )

#xcommand BLOCKS VIEW <b> [ PARAMS [<v1>] [,<vn>] ] [ TAGS <t1>,<t2> ];
=> #pragma __cstream | <b>+=mh_ReplaceBlocks( %s, "<$", "$>" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] )



//	App 		-------------------------------------------------------------------

#xcommand DEFINE APP <oApp> [ TITLE <cTitle> ] [ ON INIT <uInit> ] ;
	[ CREDENTIALS  [ VIA <cVia> ] [ NAME <cName>] [ TYPE <cType> ] [ PSW <cPsw> ] [ <time:LAPSUS, TIME> <nTime> ] ] ;
=> ;
	<oApp> := MC_App():New( [<cTitle>], [\{|| <uInit>\}], [cVia], [<cName>], [<cType>], [<cPsw>], [<nTime>] )
	

#xcommand INIT APP <oApp> => <oApp>:Init()	



#xcommand DEFINE ROUTE <cId> URL <cRule> [ CONTROLLER <cController>] [ VIEW <cView> ] [ METHOD <cMethod> ] OF <oApp> ;
=> ;
	<oApp>:oRouter:Map( <cId>, <cRule>, [<cController>], [<cView>], [<cMethod>] )

#xcommand INIT APP <oApp> => <oApp>:Init()

//	Request		-------------------------------------------------------------------	

#xcommand DEFINE <cVar> POST <cParameter> [TYPE <cType>] [DEFAULT <cDefault>] OF <oController> ;
=> ;
	<cVar> := <oController>:oRequest:Post( <cParameter>, [<cDefault>], [<cType>] )
	
#xcommand DEFINE <cVar> GET  <cParameter> [TYPE <cType>] [DEFAULT <cDefault>] OF <oController> ;
=> ;
	<cVar> := <oController>:oRequest:Get( <cParameter>, [<cDefault>], [<cType>] )	



//	Validator	-------------------------------------------------------------------	

#xcommand DEFINE VALIDATOR <oValidator> WITH <hData> ;
	[<err:ERROR ROUTE, DEFAULT> <cRoute>] [<json:ERROR JSON> ] ;
=> ;
	<oValidator> := MC_Validator():New( <hData>, [<cRoute>], [<.json.>]  )
	
#xcommand PARAMETER <cParameter> [NAME <cName>] [ ROLES <cRoles> ] [FORMATTER <cFormat>] OF <oValidator> ;
=> ;
	<oValidator>:Set( <cParameter>, <cRoles>, [<cName>], [<cFormat>] )
	
#xcommand RUN VALIDATOR <oValidator> => <oValidator>:Run()


//	Middleware	-------------------------------------------------------------------

#xcommand AUTENTICATE CONTROLLER <oController> [ VIA <cVia> ] [ TYPE <cType> ] ;
    [ <err:ERROR ROUTE, DEFAULT> <cErrorRoute> [WITH <aParams>] ] ;
	[ <exc:EXCEPTION> <cMethod,...> ] [ <json:ERROR JSON> [<hError>]] [ <code:ERROR CODE> [<nErrorCode>] ];
	[ TIME <nTime> ];
=> ;
	if ! <oController>:Middleware( [<cVia>], [<cType>], [<cErrorRoute>], [<nErrorCode>], [\{<cMethod>\}], [<hError>], [<aParams>], [<nTime>] ) ;;	
		return nil ;;
	endif;;
	
#xcommand CREATE TOKEN <cToken> OF <oController> [ WITH <hTokenData> ] [ TIME <nTime> ] => ;
	<cToken> := <oController>:oMiddleware:SetToken( [<hTokenData>], [<nTime>] )	
	
#xcommand CREATE JWT <cToken> OF <oController> [ WITH <hTokenData> ] [ TIME <nTime> ] => ;
	<cToken> := <oController>:oMiddleware:SetJWT( [<hTokenData>], [<nTime>] )	

#xcommand CLOSE JWT OF <oController> => <oController>:oMiddleware:DeleteToken()
#xcommand CLOSE TOKEN OF <oController> => <oController>:oMiddleware:DeleteToken()
	
#xcommand GET JWT DATA <hData> OF <oController> => <hData> := <oController>:oMiddleware:GetData()	
#xcommand GET TOKEN DATA <hData> OF <oController> => <hData> := <oController>:oMiddleware:GetData()	
	


#endif /* _MERCURY_CH */