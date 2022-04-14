#include 'hbclass.ch'
#include {% TWebInclude() %}

CLASS TraceModel FROM DbfCdxProvider 

	METHOD New()             		CONSTRUCTOR	
	
	METHOD Insert()
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TraceModel

	::Open( AppPathData() + 'trace.dbf', AppPathData() + 'trace.cdx')	

RETU SELF

//----------------------------------------------------------------------------//

METHOD Insert() CLASS TraceModel

	local oCounter := CounterModel():New()
	
	(::cAlias)->( DbAppend() )
	
	(::cAlias)->id 	:= oCounter:Get( 'TRK' )
	(::cAlias)->date 	:= date()
	(::cAlias)->time 	:= time()
	(::cAlias)->ip 	:= AP_GETENV( 'REMOTE_ADDR' )

	(::cAlias)->( DbCommit() )

RETU nil 

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/countermodel.prg" ) %}
