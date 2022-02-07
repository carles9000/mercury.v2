#ifndef _MERCURY_CH
#define _MERCURY_CH

#define MERCURY_PATH 			'lib/mercury/'

#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  If( <uVar1> == nil, <uVar1> := <uVal1>, ) ;;
                [ If( <uVarN> == nil, <uVarN> := <uValN>, ); ]
				

#xcommand TRY  => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS

#xcommand ? [<explist,...>] => AP_Echo( '<br>' [,<explist>] )
#xcommand ?? [<explist,...>] => AP_Echo( [<explist>] )

#xcommand BLOCKS TO <b> [ PARAMS [<v1>] [,<vn>] ] [ TAGS <t1>,<t2> ];
=> #pragma __cstream | <b>+=mh_ReplaceBlocks( %s, "{{", "}}" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] )

#xcommand BLOCKS VIEW <b> [ PARAMS [<v1>] [,<vn>] ] [ TAGS <t1>,<t2> ];
=> #pragma __cstream | <b>+=mh_ReplaceBlocks( %s, "<$", "$>" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] )


#define CRLF 			hb_OsNewLine()

/*	-----------------------------------------------	*/

#xcommand DEFINE APP <oApp> ;
=> ;
	<oApp> := MC_App():New()
	

#xcommand INIT APP <oApp> => <oApp>:Init()	



#xcommand DEFINE ROUTE <cId> URL <cRule> [ CONTROLLER <cController>] [ VIEW <cView> ] [ METHOD <cMethod> ] OF <oApp> ;
=> ;
	<oApp>:oRouter:Map( <cId>, <cRule>, [<cController>], [<cView>], [<cMethod>] )

#xcommand INIT APP <oApp> => <oApp>:Init()

//	Validator	-------------------------------------------------------------------	

#xcommand DEFINE VALIDATOR <oValidator> WITH <hData> ;
	[<err:ERROR ROUTE, DEFAULT> <cRoute>] [<json:ERROR JSON> ] ;
=> ;
	<oValidator> := MC_Validator():New( <hData>, [<cRoute>], [<.json.>]  )
	
#xcommand PARAMETER <cParameter> [NAME <cName>] [ ROLES <cRoles> ] [FORMATTER <cFormat>] OF <oValidator> ;
=> ;
	<oValidator>:Set( <cParameter>, <cRoles>, [<cName>], [<cFormat>] )
	
#xcommand RUN VALIDATOR <oValidator> => <oValidator>:Run()



#endif /* _MERCURY_CH */