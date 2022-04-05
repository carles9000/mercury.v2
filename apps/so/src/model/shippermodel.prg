#include {% TWebInclude() %}

CLASS ShipperModel FROM DbfCdxProvider 

	METHOD New()             		CONSTRUCTOR	
	
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS ShipperModel

	::Open( AppPathData() + 'shipper.dbf', AppPathData() + 'shipper.cdx')
	
	//	Define main tag cdx index

		::cId 		:= 'id_type'

	//	Define data Dataset. These will be the only fields that I will allow to work
	
		DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

			FIELD 'id_type' 	UPDATE  OF ::oDataset
			FIELD 'name' 		UPDATE  OF ::oDataset
			
		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .t. 
	
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 		:= { 'id_type', 'id_type', {|u| upper(u) }  }
		::hSearch[ 'nombre' ] 	:= { 'nombre', 'name', {|u| lower(u) } }		

RETU SELF


//----------------------------------------------------------------------------//
{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
