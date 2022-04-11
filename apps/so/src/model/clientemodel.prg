#include {% TWebInclude() %}


CLASS ClienteModel  FROM DbfCdxProvider

	METHOD New()             		CONSTRUCTOR
	
	METHOD GetName( nId )
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS ClienteModel

	::Open( AppPathData() + 'cliente.dbf', AppPathData() + 'cliente.cdx')
	

	//	Define data Dataset. These will be the only fields that I will allow to work
	
	DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

		FIELD 'id_cli' 		UPDATE  VALID {|o,uValue,hRow, cAction| Cli_NewId( o, uValue, hRow, cAction ) }  OF ::oDataset
		FIELD 'nom_cli'		UPDATE  OF ::oDataset
		FIELD 'cont_nom'	UPDATE  OF ::oDataset
		FIELD 'cont_ape'	UPDATE  OF ::oDataset
		FIELD 'cont_tit'	UPDATE  OF ::oDataset
		FIELD 'cont_carg'	UPDATE  OF ::oDataset
		FIELD 'vent_last'	UPDATE  OF ::oDataset
		FIELD 'dir1'		UPDATE  OF ::oDataset
		FIELD 'dir2'		UPDATE  OF ::oDataset
		FIELD 'ciudad'		UPDATE  OF ::oDataset
		FIELD 'region'		UPDATE  OF ::oDataset
		FIELD 'pais'		UPDATE  OF ::oDataset
		FIELD 'cp'			UPDATE  OF ::oDataset
		FIELD 'mail'		UPDATE  OF ::oDataset
		FIELD 'url'			UPDATE  OF ::oDataset
		FIELD 'tlf'			UPDATE  OF ::oDataset
		FIELD 'fax'			UPDATE  OF ::oDataset

		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .T. 
	
	//	Define main tag cdx index

		::cId 		:= 'id'
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 		:= { 'id_cli', 'id_cli' }
		::hSearch[ 'cliente' ] := { 'nom_cli', 'nom_cli', {|u| lower(u)} }		

RETU SELF


//----------------------------------------------------------------------------//

function Cli_NewId( o, uValue, hRow, cAction  )

	local oPedido
	local lValid 	:= .t.

	if Valtype(uValue) == 'C' .and. At( '$', uValue ) > 0
		
		oCounter := CounterModel():New()
		
		hRow[ 'id_cli' ] := oCounter:Get( 'CLI' )
		
	else 
		
		do case
			case cAction == 'D'			
			
				oPedido := PedidoModel():New()
				
				nTotal := oPedido:CountId( 'cliente', uValue )	//	Return total id_cli used in pedido
				
				if nTotal > 0
					o:SetError( "Client " + mh_valtochar(uValue) + " ,can't be deleted. Referenced " + ltrim(str( nTotal)) + " times")
					lValid := .f. 
				endif

		endcase		
		
	endif 
	
retu lValid 

//----------------------------------------------------------------------------//

METHOD GetName( nId ) CLASS ClienteModel

	local cName 	:= ''
	
	local hRow 	:= ::GetId( nId )
	
	if !empty( hRow )
		cName := hRow[ 'nom_cli' ]
	endif 
retu cName 

//----------------------------------------------------------------------------//

{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}
{% mh_LoadFile( "/src/model/countermodel.prg" ) %}