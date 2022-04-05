#include {% TWebInclude() %}

CLASS PedidoModel FROM DbfCdxProvider 

	DATA oCliente
	DATA oEmpleado
	DATA oPedidoPos
	DATA oCounter

	METHOD New()             		CONSTRUCTOR	
	
	METHOD LoadRow()
	
	METHOD Load( nId )
	METHOD Save()
	
	
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
			FIELD 'data_req'	UPDATE  OF ::oDataset
			FIELD 'notes'		UPDATE  OF ::oDataset
			FIELD 'id_shipper'	UPDATE  OF ::oDataset

		
	//	Define Special row Load
	
		::bLoadRow := {|| ::LoadRow() }
		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .F. 
	
	//	Define main tag cdx index

		::cId 		:= 'id'
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 		:= { 'id_ped', 'id_ped' }
		::hSearch[ 'cliente' ] := { 'id_cli', 'id_cli' }
		
	//	Activate ID 
	
		_d( 'FOCUS', OrdSetFocus( ::hSearch[ 'id' ][1] ) )
		(::cAlias)->( OrdSetFocus( ::hSearch[ 'id' ][1] ) )
		
		
		
	::oCliente  	:= ClienteModel():New()
	::oEmpleado 	:= EmpleadoModel():New()
	::oPedidoPos 	:= PedidoPosModel():New()
	::oCounter 	:= CounterModel():New()


RETU SELF


//----------------------------------------------------------------------------//

METHOD LoadRow() CLASS PedidoModel

	local hRow := ::oDataset:Row()
	local h 
	
	//	LEFT JOIN Cliente	------------------------------------------

	if !empty( hRow[ 'id_cli' ] )		
		
		h := ::oCliente:GetId( hRow[ 'id_cli' ]) 

		if len(h) > 0
		
			hRow[ 'nom_cli' ] := h[ 'nom_cli' ]
	
		endif		

		
	endif 
	
	
	//	LEFT JOIN Empleado	---------------------------------------	
	
	if !empty( hRow[ 'id_emp' ] )

		h := ::oEmpleado:GetId( hRow[ 'id_emp' ]) 

		if len(h) > 0
		
			hRow[ 'nom_emp' ] := h[ 'apellido' ] + ', ' + h[ 'nombre' ]
	
		endif
		
	endif 	
	
	
RETU hRow


//----------------------------------------------------------------------------//

METHOD Load( nId, lAllData ) CLASS PedidoModel

	local hPedido  :=  {=>}
	
	DEFAULT lAllData TO .f. 
	
	(::cAlias)->( OrdSetFocus( ::hSearch[ 'id' ][1] ) )

	_d( 'FOCUS', ::hSearch[ 'id' ][1] )
	_d( 'LOAD', nId )
	
	(::cAlias)->( DbSeek( nId ) )
	
	_d( (::cAlias)->id_ped )
	
	if (::cAlias)->id_ped == nId 
	
	_d( 'DINS' )
	
		hPedido[ 'cab' ] := ::LoadRow()
		hPedido[ 'pos' ] := ::oPedidoPos:LoadPos( nId )		
		
		if lAllData 						
		
			hPedido[ 'ocliente' ] := ::oCliente:GetId( hPedido[ 'cab'][ 'id_cli'] ) 
			hPedido[ 'oempleado'] := ::oEmpleado:GetId( hPedido[ 'cab'][ 'id_emp'] ) 
			
		endif 
		
	endif 
	
RETU hPedido 

//----------------------------------------------------------------------------//

METHOD Save( hCab, aPos, hError ) CLASS PedidoModel

	local cAliasPos 	:= ::oPedidoPos:cAlias
	local lSave 		:= .f.
	local lLock 		:= .f.
	local lLock_Pos 	:= .f.
	local n, nPos, oItem, nRecno, nTotal
	
	//	
		(cAliasPos)->( OrdSetFocus( 'id' )  )
		
		hError := {=>}
	
_d( 'SAVE' )
_d( aPos )	

_d( hCab )	
	
	//	Existe Cliente ?
	
		

	
	//	Check Id 
		//Si Id == '' --> Nuevo 
		//Si Id existe --> Load, Lock and wait 
	
		if empty( hCab['id'] ) 
	
			(::cAlias)->( DbAppend() )
			
			hCab[ 'id' ] := ::oCounter:Get( 'PDC' )
			
			if hCab[ 'id' ] == -1
				
				//	Error 
				
			endif 			
			
			(::cAlias)->id_ped := hCab[ 'id' ]
			
			lLock := .t.
		
		else 
_d( 'Proc1b')		

			(::cAlias)->( DbSeek( hCab[ 'id' ] ) )
			
			if (::cAlias)->id_ped == hCab[ 'id' ]
		
				lLock := (::cAlias)->( DbRlock() )
				
			endif
			
		endif
		
	//
	
	if !lLock
	
		_d( 'Error bloqueo head')
		retu
	
	endif 
		
		
_d( 'Proc2', lLock)	

	//	Save Pos 
	
		nPos := len( aPos )
		
		for n := 1 to nPos 
_d( 'Proc3' )		
			oItem := aPos[n]		
		
_d( 'Proc3->' + oItem[ 'action'] )		

			lLock_Pos := .f.
_d('proc3-1')
			DO CASE
				case oItem[ 'action'] == 'A' 
					
_d('proc3-1a')
						lLock_Pos := (cAliasPos)->( DbAppend() )				
					_d( 'LOCK', lLock_Pos)
						nIdPos := ::oCounter:Get( 'PDP' )
_d( 'NIDPOS', nIdPos )						
						
						if nIdPos == -1 
						
							//	Error ----
							
							lLock_Pos := .f.
							
						else 
							lLock_Pos := .t.
						
						endif 
						
				case oItem[ 'action'] == 'U' 
_d('proc3-1b')
				
				_d( oItem[ 'action'] )
				_d( oItem['id'] )
				
					nIdPos := if( valtype(oItem['id']) == 'N', oItem['id'], val(oItem['id']))
				
					(cAliasPos)->( DbSeek( nIdPos ) )
					
					if (cAliasPos)->id == nIdPos 
						lLock_Pos := (cAliasPos)->( DbRlock() )
					endif
					
				case oItem[ 'action'] == 'D' 
				
				_d( oItem[ 'action'] )
				_d( oItem['id'] )
				
					
					nIdPos := if( valtype(oItem['id']) == 'N', oItem['id'], val(oItem['id']))
				
					(cAliasPos)->( DbSeek( nIdPos ) )
					
					if (cAliasPos)->id == nIdPos 
						if (cAliasPos)->( DbRlock() )
							(cAliasPos)->( DbDelete() )
						endif
					endif										
					
			endcase
			
_d('proc3-2')
			if lLock_Pos 
_d( oItem )
_d('proc3-41')			
				(cAliasPos)->id      	:= nIdPos
_d('proc3-42')			
				(cAliasPos)->id_ped  	:= hCab['id']
_d('proc3-43')			
				(cAliasPos)->id_prod 	:= Val( oItem['row']['id_prod'] )
_d('proc3-44')			
				(cAliasPos)->precio  	:= Val( oItem['row']['precio'] )
_d('proc3-45')			
				(cAliasPos)->ctd    	:= Val( oItem['row']['ctd'] )			
			
				
				
_d('proc3-46')			
				
			endif 		
		
		next 
	
	//	Save Head 
	
		//	Count Total Pedido
		
		nTotal := 0
	
		(cAliasPos)->( OrdSetFocus( 'id_ped' ) )
		
		(cAliasPos)->( DbSeek( hCab['id'] ) )
		
_d('proc3-5')			
		while (cAliasPos)->id_ped == hCab['id']  .and. (cAliasPos)->( !eof() )
		
			nTotal += ( (cAliasPos)->precio * (cAliasPos)->ctd )
		
			(cAliasPos)->( DbSkip() )
		end 
		
_d('proc3-6')			
		
		//	Update Header Pedido 
		
			(::cAlias)->id_ped 	:= hCab['id']
			(::cAlias)->id_cli 	:= hCab[ 'id_cli' ]
			(::cAlias)->id_emp 	:= hCab[ 'id_emp' ]
			(::cAlias)->total 		:= nTotal 

			(::cAlias)->notes 		:= hCab['notes'] 
			(::cAlias)->id_shipper 	:= hCab['id_shipper'] 
			
			if  valtype(hCab['data_ped']) == 'D'
				(::cAlias)->data_ped := hCab['data_ped'] 
			endif
			
			if  valtype(hCab['data_req']) == 'D'
				(::cAlias)->data_req := hCab['data_req'] 
			endif				
		
		
	//	Commits
		
		(::cAlias)->( DbCommit() )
		(cAliasPos)->( DbCommit() )														


RETU lSave 



//----------------------------------------------------------------------------//
{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/clientemodel.prg" ) %}
{% mh_LoadFile( "/src/model/empleadomodel.prg" ) %}
{% mh_LoadFile( "/src/model/pedidoposmodel.prg" ) %}
{% mh_LoadFile( "/src/model/countermodel.prg" ) %}
