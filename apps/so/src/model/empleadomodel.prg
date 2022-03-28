#include {% TWebInclude() %}


CLASS EmpleadoModel  FROM DbfCdxProvider

	METHOD New()             		CONSTRUCTOR

				
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS EmpleadoModel

	::Open( AppPathData() + 'empleado.dbf', AppPathData() + 'empleado.cdx')
	

	//	Define data Dataset. These will be the only fields that I will allow to work
	
	DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

		FIELD 'id_emp' 		UPDATE  OF ::oDataset
		FIELD 'apellido'	UPDATE  OF ::oDataset
		FIELD 'nombre'		UPDATE  OF ::oDataset
		FIELD 'cargo'		UPDATE  OF ::oDataset
		
		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .T. 
	
	//	Define main tag cdx index

		::cId 		:= 'id'
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 		:= { 'id_emp', 'id_emp' }
		::hSearch[ 'apellido' ] := { 'apellido', 'apellido' }		

RETU SELF
