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

			FIELD 'id_type' 	UPDATE  VALID {|o,uValue,hRow,cAction| ValidShipper( o, uValue, hRow, cAction  ) } OF ::oDataset
			FIELD 'name' 		UPDATE  OF ::oDataset
			
		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .t. 
	
	
	//	Define Searchs by Tag 
	
								//	  cTag    ,  cField , Format
		::hSearch[ 'id' ] 		:= { 'id_type', 'id_type', {|u| upper(u) }  }
		::hSearch[ 'nombre' ] 	:= { 'name', 'name', {|u| lower(u) } }		

RETU SELF
//----------------------------------------------------------------------------//

function ValidShipper( o, uValue, hRow, cAction  )

	local oPedido
	local lValid 	:= .t.
	local nTotal 

	do case
		case cAction == 'A'	 .or. cAction == 'U'			
		
			hRow[ 'id_type' ] := upper( uValue )
			
			lValid := .t. 
			
		case cAction == 'D'			
		
			oPedido := PedidoModel():New()
			
			nTotal := oPedido:CountId( 'shipper', uValue )	//	Return total id_shipper used in pedido
			
			if nTotal > 0
				o:SetError( "Shipper " + mh_valtochar(uValue) + " ,can't be deleted. Referenced " + ltrim(str( nTotal)) + " times")
				lValid := .f. 
			endif

	endcase		

	
retu lValid 

//----------------------------------------------------------------------------//
{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}
