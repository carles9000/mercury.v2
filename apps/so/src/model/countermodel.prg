#include {% TWebInclude() %}


CLASS CounterModel  FROM DbfCdxProvider

	METHOD New()             		CONSTRUCTOR

	METHOD Get()
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS CounterModel

	::Open( AppPathData() + 'counter.dbf', AppPathData() + 'counter.cdx')
	

	//	Define data Dataset. These will be the only fields that I will allow to work
	
	DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

		FIELD 'type' 		UPDATE  VALID {|o,uValue,hRow| (hRow['type'] := upper(uValue), .t. ) }  OF ::oDataset
		FIELD 'module'		UPDATE  OF ::oDataset
		FIELD 'counter'		UPDATE  OF ::oDataset

		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .T. 
	
	//	Define main tag cdx index

		::cId 		:= 'type'
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'type' ] 		:= { 'type', 'type' , {|u| upper(u) }}		
		::hSearch[ 'module' ] 		:= { 'module', 'module', {|u| lower(u) } }		
		
	//	Activate tag
	
		(::cAlias)->( OrdSetFocus( ::hSearch[::cId ][1] ) )

RETU SELF

//----------------------------------------------------------------------------//

METHOD Get( cType ) CLASS CounterModel

	local lDone 	:= .f. 
	local nCount	:= -1
	local nLapsus 	:= hb_milliseconds() + 5000 

	DEFAULT cType To ''

	
	cType := upper(cType)

	(::cAlias)->( DbSeek( cType ) )
	
	if (::cAlias)->type == cType 
	
		while !lDone .and. hb_milliseconds() <= nLapsus
	
		
			if (::cAlias)->( DbRlock() ) 

				(::cAlias)->counter := (::cAlias)->counter + 1 
				
				nCount := (::cAlias)->counter

				(::cAlias)->( DbUnlock() )
			
				lDone := .t.
				
			else 
				//	Syswait(0.1)
				
			endif 											

		end  
	
	endif 			

RETU nCount 

//----------------------------------------------------------------------------//

{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
