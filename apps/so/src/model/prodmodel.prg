#include {% TWebInclude() %}

CLASS ProdModel FROM DbfCdxProvider 

	METHOD New()             		CONSTRUCTOR	
	
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS ProdModel

	::Open( AppPathData() + 'producto.dbf', AppPathData() + 'producto.cdx')
	
	//	Define main tag cdx index

		::cId 		:= 'id'

	//	Define data Dataset. These will be the only fields that I will allow to work
	
		DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

			FIELD 'id_prod' 	UPDATE  OF ::oDataset
			FIELD 'nombre' 		UPDATE  OF ::oDataset
			FIELD 'color' 		UPDATE  OF ::oDataset
			FIELD 'tamano' 		UPDATE  OF ::oDataset
			FIELD 'precio' 		UPDATE  OF ::oDataset

		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .t. 
	
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 		:= { 'id_prod', 'id_prod' }
		::hSearch[ 'nombre' ] 	:= { 'nombre', 'nombre', {|u| lower(u) } }
		::hSearch[ 'tamano' ] 	:= { 'tamano', 'tamano' }
		
		
		(::cAlias)->( OrdSetFocus( ::hSearch[ 'id' ][1] ) )


RETU SELF


//----------------------------------------------------------------------------//
{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
