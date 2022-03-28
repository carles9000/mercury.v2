#include {% TWebInclude() %}

CLASS PedidoModel FROM DbfCdxProvider 

	DATA oCliente
	DATA oEmpleado

	METHOD New()             		CONSTRUCTOR	
	
	METHOD LoadRow()
	
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS PedidoModel

	::Open( AppPathData() + 'pedidos.dbf', AppPathData() + 'pedidos.cdx')
	

	//	Define data Dataset. These will be the only fields that I will allow to work
	
		DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

			FIELD 'id_ped' 		UPDATE  OF ::oDataset
			FIELD 'id_cli'		UPDATE  OF ::oDataset
			FIELD 'id_emp'		UPDATE  OF ::oDataset
			FIELD 'total'		UPDATE  OF ::oDataset
			FIELD 'data_ped'	UPDATE  OF ::oDataset

		
	//	Define Special row Load
	
		::bLoadRow := {|| ::LoadRow() }
		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .F. 
	
	//	Define main tag cdx index

		::cId 		:= 'id'
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 		:= { 'id_ped', 'id_ped' }
		::hSearch[ 'cliente' ] := { 'id_cli', 'id_cli' }
		
		
	::oCliente := ClienteModel():New()
	::oEmpleado := EmpleadoModel():New()


RETU SELF


//----------------------------------------------------------------------------//

METHOD LoadRow() CLASS PedidoModel

	local hRow := ::oDataset:Row()
	local h 
	
	//	LEFT JOIN Cliente	------------------------------------------

	if !empty( hRow[ 'id_cli' ] )

		h := ::oCliente:GetId( hRow[ 'id_cli' ]) 

		if len(h) > 0
		
			hRow[ 'nom_cli' ] := h[1][ 'nom_cli' ]
	
		endif
		
	endif 
	
	
	//	LEFT JOIN Empleado	---------------------------------------	
	
	if !empty( hRow[ 'id_emp' ] )

		h := ::oEmpleado:GetId( hRow[ 'id_emp' ]) 

		if len(h) > 0
		
			hRow[ 'nom_emp' ] := h[1][ 'apellido' ] + ', ' + h[1][ 'nombre' ]
	
		endif
		
	endif 	
	
	
RETU hRow


//----------------------------------------------------------------------------//
{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/clientemodel.prg" ) %}
{% mh_LoadFile( "/src/model/empleadomodel.prg" ) %}
