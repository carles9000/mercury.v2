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
	
		hError := {=>}
	
_d( 'SAVE' )	
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
		
			lNew := At( '$', oItem[ '_recno' ] ) > 0 
			
			if lNew
			
				lLock_Pos := (cAliasPos)->( DbAppend() )				
			
				nIdPos := ::oCounter:Get( 'PDP' )
				
				if nIdPos == -1 
				
					//	Error ----
				
				endif 
				
			
			else 																			
			
				lLock_Pos := (cAliasPos)->( DbRlock() )
				
				nIdPos := (cAliasPos)->id 
				
			endif 
			
			if lLock_Pos 
			
				(cAliasPos)->id      	:= nIdPos
				(cAliasPos)->id_ped  	:= hCab['id']
				(cAliasPos)->id_prod 	:= Val( oItem[ 'id_prod' ] )
				(cAliasPos)->precio  	:= Val( oItem[ 'precio' ] )
				(cAliasPos)->ctd    	:= Val( oItem[ 'ctd' ] )			
				
			endif 		
		
		next 
	
	//	Save Head 
	
		//	Count Total Pedido
		
		nTotal := 0
	
		(cAliasPos)->( DbSeek( hCab['id'] ) )
		
		while (cAliasPos)->id_ped == hCab['id']  .and. (cAliasPos)->( !eof() )
		
			nTotal += ( (cAliasPos)->precio * (cAliasPos)->ctd )
		
			(cAliasPos)->( DbSkip() )
		end 
		
		
		//	Update Header Pedido 
		
			(::cAlias)->id_ped 	:= hCab['id']
			(::cAlias)->id_cli 	:= hCab[ 'id_cli' ]
			(::cAlias)->id_emp 	:= hCab[ 'id_emp' ]
			(::cAlias)->total 		:= nTotal 				
		
		
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
