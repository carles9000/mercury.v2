#include {% TWebInclude() %}


CLASS EmpleadoModel  FROM DbfCdxProvider

	METHOD New()             		CONSTRUCTOR

				
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS EmpleadoModel

	::Open( AppPathData() + 'empleado.dbf', AppPathData() + 'empleado.cdx')
	

	//	Define data Dataset. These will be the only fields that I will allow to work
	
	DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

		FIELD 'id_emp' 			UPDATE  VALID {|o,uValue,hRow,cAction| ValidEmp( o, uValue, hRow, cAction  ) } OF ::oDataset
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

function ValidEmp( o, uValue, hRow, cAction  )

	local oPedido
	local lValid 	:= .t.
	local nTotal 

	do case
		case cAction == 'A'	 .or. cAction == 'U'			
		
			if Valtype(uValue) == 'C' .and. At( '$', uValue ) > 0
				
				oCounter := CounterModel():New()
				
				hRow[ 'id_emp' ] := oCounter:Get( 'EMP' )
				
			endif 
			
			lValid := .t. 
			
		case cAction == 'D'			
		
			oPedido 	:= PedidoModel():New()			
			
			nTotal := oPedido:CountId( 'emp', uValue )	//	Return total id_prod used in pedidopos
			
			if nTotal > 0
				o:SetError( "Empleado " + mh_valtochar(uValue) + " ,can't be deleted. Referenced " + ltrim(str( nTotal)) + " times")
				lValid := .f. 
			endif			

	endcase		

	
retu lValid 

//----------------------------------------------------------------------------//


{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}
{% mh_LoadFile( "/src/model/countermodel.prg" ) %}