#include {% TWebInclude() %}

CLASS Tipo_ProModel FROM DbfCdxProvider 

	METHOD New()             		CONSTRUCTOR	
	
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS Tipo_ProModel

	::Open( AppPathData() + 'tipo_pro.dbf', AppPathData() + 'tipo_pro.cdx')
	
	//	Define main tag cdx index

		::cId 		:= 'id_type'

	//	Define data Dataset. These will be the only fields that I will allow to work
	
		DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

			FIELD 'id_type' 	UPDATE  OF ::oDataset
			FIELD 'nombre' 		UPDATE  OF ::oDataset
			FIELD 'descripcio'	UPDATE  OF ::oDataset						
		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .t. 
	
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 		:= { 'id_type' }
		::hSearch[ 'nombre' ] 	:= { 'nombre', {|u| lower(u) } }		

RETU SELF


//----------------------------------------------------------------------------//
{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
