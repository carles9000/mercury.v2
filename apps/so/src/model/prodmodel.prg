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

			FIELD 'id_prod' 	UPDATE  VALID {|o,uValue,hRow,cAction| ValidProd( o, uValue, hRow, cAction  ) } OF ::oDataset
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

function ValidProd( o, uValue, hRow, cAction  )

	local oPedido
	local lValid 	:= .t.
	local nTotal 

	do case
		case cAction == 'A'	 .or. cAction == 'U'			
		
			if Valtype(uValue) == 'C' .and. At( '$', uValue ) > 0
				
				oCounter := CounterModel():New()
				
				hRow[ 'id_prod' ] := oCounter:Get( 'TPR' )
				
			endif 
			
			lValid := .t. 
			
		case cAction == 'D'			
		
			oPedido 	:= PedidoModel():New()
			oPedidoPos := oPedido:oPedidoPos
			
			nTotal := oPedidoPos:CountId( 'id_prod', uValue )	//	Return total id_prod used in pedidopos
			
			if nTotal > 0
				o:SetError( "Product " + mh_valtochar(uValue) + " ,can't be deleted. Referenced " + ltrim(str( nTotal)) + " times")
				lValid := .f. 
			endif

	endcase		

	
retu lValid 

//----------------------------------------------------------------------------//
/*
function Prod_NewId( o, uValue, hRow )

	if Valtype(uValue) == 'C' .and. At( '$', uValue ) > 0
		
		oCounter := CounterModel():New()
		
		hRow[ 'id_prod' ] := oCounter:Get( 'TPR' )
		
	endif 
	
retu .t. 
*/
//----------------------------------------------------------------------------//
{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}
{% mh_LoadFile( "/src/model/countermodel.prg" ) %}
