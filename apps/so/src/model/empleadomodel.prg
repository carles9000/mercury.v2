#include {% TWebInclude() %}


CLASS EmpleadoModel  FROM DbfCdxProvider

	METHOD New()             		CONSTRUCTOR

				
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS EmpleadoModel

	::Open( AppPathData() + 'empleado.dbf', AppPathData() + 'empleado.cdx')
	

	//	Define data Dataset. These will be the only fields that I will allow to work
	
	DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

		FIELD 'id_emp' 			UPDATE  VALID {|o,uValue,hRow| Emp_NewId( o, uValue, hRow ) } OF ::oDataset
		FIELD 'apellido'  		UPDATE  OF ::oDataset
		FIELD 'nombre' 			UPDATE  OF ::oDataset
		FIELD 'cargo'  			UPDATE  OF ::oDataset
		FIELD 'data_nac'  		UPDATE  OF ::oDataset
		FIELD 'data_cont' 		UPDATE  OF ::oDataset
		FIELD 'tlf'  			UPDATE  OF ::oDataset
		FIELD 'ext'  			UPDATE  OF ::oDataset
		
		
		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .T. 
	
	//	Define main tag cdx index

		::cId 		:= 'id'
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 			:= { 'id_emp', 'id_emp' }
		::hSearch[ 'apellido' ] 	:= { 'apellido', 'apellido', {|u| lower(u)} }		

RETU SELF

//----------------------------------------------------------------------------//

function Emp_NewId( o, uValue, hRow )

	if Valtype(uValue) == 'C' .and. At( '$', uValue ) > 0
		
		oCounter := CounterModel():New()
		
		hRow[ 'id_emp' ] := oCounter:Get( 'EMP' )
		
	endif 
	
retu .t. 

//----------------------------------------------------------------------------//

{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/countermodel.prg" ) %}