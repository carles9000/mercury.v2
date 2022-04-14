#include 'hbclass.ch'
#include {% TWebInclude() %}

CLASS TraceModel FROM DbfCdxProvider 

	METHOD New()             		CONSTRUCTOR	
	
	METHOD Insert()
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TraceModel

	::Open( AppPathData() + 'trace.dbf', AppPathData() + 'trace.cdx')

	//	Define main tag cdx index

		::cId 		:= 'id'

	//	Define data Dataset. These will be the only fields that I will allow to work
	
		DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

			FIELD 'id' 		OF ::oDataset
			FIELD 'date' 	OF ::oDataset
			FIELD 'time' 	OF ::oDataset
			FIELD 'ip' 		OF ::oDataset			
			
		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .t. 	
	
	//	Define Searchs by Tag 
	
								//	  cTag    ,  cField , Format
		::hSearch[ 'id' ] 		:= { 'id', 'id' }
		

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
