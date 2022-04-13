CLASS Dashboard

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()	

	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Dashboard

	AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Dashboard


	local oPedido		:= PedidoModel():New()	
	local oCliente		:= oPedido:oCliente
	local hSales 		:= {=>}
	local aSales 		:= {}
	local hHisto 		:= {=>}
	
	cAlias := oPedido:cAlias 
	
	//	Historial TOP Clientes
	
		(cAlias)->( DbGoTop() )
		
		while (cAlias)->( !eof() )

			id_cli := (cAlias)->id_cli
			
			nPos := Ascan( aSales, {|a| a[1] == id_cli })
			
			if nPos == 0 		
				Aadd( aSales, { id_cli, oCliente:GetName( id_cli ), (cAlias)->total } )		
			else 		
				aSales[nPos][3] += (cAlias)->total		
			endif

			
			(cAlias)->( dbskip() )
		
		end 	
		
		ASORT(aSales,,, { |x, y| x[3] > y[3] } )
		
		
		
		
		aClients_Txt := {	oCliente:GetName( aSales[1][1] ),;
							oCliente:GetName( aSales[2][1] ),;
							oCliente:GetName( aSales[3][1] ),;
							oCliente:GetName( aSales[4][1] ),;
							oCliente:GetName( aSales[5][1] );
						}
		
		aClients_Total	:= { aSales[1][3], aSales[2][3],aSales[3][3],aSales[4][3],aSales[5][3] }

		
		
		/*
		? aSales[1]
		? aSales[2]
		? aSales[3]
		? aSales[4]
		? aSales[5]
		*/
		
	//	Ventas por año 
	
		hHisto[ '2020' ] := Historial( cAlias, 2020 )
		hHisto[ '2021' ] := Historial( cAlias, 2021 )
		hHisto[ '2022' ] := Historial( cAlias, 2022 )
	
		/*
		? hHisto[ '2020' ]
		? hHisto[ '2021' ]
		? hHisto[ '2022' ]
		*/



	oController:View( 'dashboard/est_1.view', 200, hHisto, aClients_Txt, aClients_Total, aSales )

RETU NIL

//	---------------------------------------------------------------	//


function Historial( cAlias, nYear )

	local aReg := array(12)
	
	aReg := AFill( aReg, 0 )

	(cAlias)->( DbGoTop() )
	
	//	Ok, ok, we can use index but maybe you can do it....	
	
	while (cAlias)->( !eof() )						
		
		if Year( (cAlias)->data_ped ) == nYear 

			nMonth := month( (cAlias)->data_ped  )
		
			aReg[nMonth] += (cAlias)->total 						
		
		endif
		
		(cAlias)->( dbskip() )
	
	end 	
	
retu aReg 


//	---------------------------------------------------------------	//

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}
	{% mh_LoadFile( "/src/model/clientemodel.prg" ) %}
	{% mh_LoadFile( "/src/model/empleadomodel.prg" ) %}