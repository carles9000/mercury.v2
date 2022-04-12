CLASS Report

	METHOD New() 	CONSTRUCTOR
	
	METHOD Invoice()	

	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Report

	//AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Invoice( oController ) CLASS Report

	local cLogo 	:= AppPathImg() + 'logo_report.png'
	local oPedido 	:= PedidoModel():New()
	local hParam 	:= GetMsgServer()	
	local cFile , cUrlFile	
	local oPrn, oValidator, hInfo
	local hCom 	:= {=>}
	
	DEFINE VALIDATOR oValidator WITH hParam
		PARAMETER 'id' 	NAME 'Id' ROLES 'required|number|maxlen:8' FORMATTER 'tonumber' OF oValidator			
	RUN VALIDATOR oValidator 
	
	if oValidator:lError
		oController:oResponse:SendJson( { 'success' => .f., 'error' => oValidator:ErrorString() })	
		retu 
	endif	
	
	cFile 		:= AppPathReport() + 'fact' + ltrim(str( hParam['id'])) + '.pdf'
	cUrlFile 	:= AppUrlReport() + 'fact' + ltrim(str( hParam['id'])) + '.pdf'		

	hInfo := oPedido:Load( hParam[ 'id' ] , .T. )	
	

	
	if file( cFile )
		fErase( cFile )
	endif

	oPrn := InitPrn()

	oPrn:StartPage() 
	
	//	Logo 
	
		oPrn:CmSayBitmap( 0.5, 0.5, cLogo, 2.6, 2 )
		oPrn:cmSay( 0.5 ,3.5, "Charly's motorcycle", oPrn:hFont[ 'title_logo' ] ,, 0 )
		oPrn:cmSay( 1.7 ,3.6, "Let's go to hell", oPrn:hFont[ 'title_sublogo' ] ,, 0 )

	//	Bussiness
	
		hCom[ 'name' ] := "Charly's motorcycle"
		hCom[ 'dir1' ] := 'Via Augusta, 201'
		hCom[ 'tlf' ]  := '+34 930212568'
		hCom[ 'city' ] := 'Barcelona'
		hCom[ 'cif' ]  := '46521584-T'
		hCom[ 'mail' ] := 'charly@motor.com'
		
		Commerce( oPrn, hCom  )
		
	//	Pedido 
	
		LinCol( oPrn, 8.0, 2, 5, 'Nº FACTURA'	, ltrim(str(hParam['id'] )) )
		LinCol( oPrn, 8.5, 2, 5, 'Fecha'		, hInfo['cab']['data_ped'] )
		
	
		
   
   //	Client
   
		Client( oPrn, hInfo[ 'ocliente' ] )
		
	//	Grid
	
	   oPrn:cmRect( 13,  2, 26, 19, 1 )
	   oPrn:cmLine( 14,  2, 14, 19, 1 )
	   oPrn:cmLine( 25,  2, 25, 19, 1 )
	   oPrn:cmLine( 13, 4.5, 26, 4.5, 1 )
	   oPrn:cmLine( 13, 11.5, 26, 11.5, 1 )
	   oPrn:cmLine( 13, 14, 26, 14, 1 )
	   oPrn:cmLine( 13, 16.5, 26, 16.5, 1 )	
		
	   oPrn:cmSay( 13.3, 2.6, "Code", oPrn:hFont[ 'helvetica10-bold' ], 0 )
	   oPrn:cmSay( 13.3, 7, "Description", oPrn:hFont[ 'helvetica10-bold' ], 0 )
	   oPrn:cmSay( 13.3, 12.2, "Units", oPrn:hFont[ 'helvetica10-bold' ], 0 )
	   oPrn:cmSay( 13.3, 14.7, "Price", oPrn:hFont[ 'helvetica10-bold' ], 0 )
	   oPrn:cmSay( 13.3, 17, "Amount", oPrn:hFont[ 'helvetica10-bold' ], 0 )
	   
	   oPrn:cmSay( 25.3, 14.7, "TOTAL", oPrn:hFont[ 'helvetica10-bold' ], 0 )
   
   

	   
		aPos := hInfo[ 'pos' ]
		
		nRow := 14.5
		
		for n := 1 to len( aPos )
		
			oPrn:cmSay( nRow, 2.6, ltrim(str(aPos[n]['id_prod' ])), oPrn:hFont[ 'helvetica10' ], 0 )
			oPrn:cmSay( nRow, 5, aPos[n]['prod_txt' ], oPrn:hFont[ 'helvetica10' ], 0 )
			oPrn:cmSay( nRow, 12.5, ltrim(str(aPos[n]['ctd'])), oPrn:hFont[ 'helvetica10' ], 0 )
			oPrn:cmSay( nRow, 14.8, ltrim(str(aPos[n]['precio' ])), oPrn:hFont[ 'helvetica10' ], 0 )
			oPrn:cmSay( nRow, 17.3, ltrim(str(aPos[n]['precio' ]*aPos[n]['ctd' ])), oPrn:hFont[ 'helvetica10' ], 0 )
			
			nRow += 0.6 
			
		next 
	
		oPrn:cmSay( 25.3, 16.7, Transform( hInfo['cab']['total'], "99,999,999.99€" ), oPrn:hFont[ 'helvetica10-bold' ], 0 )
		
		
		oPrn:cmSay( 29, 14, '© 2021-2022 Powered by modHarbour V2', oPrn:hFont[ 'times-bolditalic' ], 0 )
   

   
	oPrn:EndPage()
  
	oPrn:Save( cFile )
	oPrn:End()

	oController:oResponse:SendJson( { 'success' => .t., 'param' => hParam, 'url' => cUrlFile, 'pedido' => hInfo } )

RETU NIL

//------------------------------------------------------------------------------

function InitPrn()   

	local oPrn := TPdf():New( "list" )
   
	oPrn:LoadedFonts := { "Verdana" }
   
    oPrn:hFont[ 'helvetica24' ] 		:= oPrn:DefineFont( 'Helvetica', 24 )
    oPrn:hFont[ 'helvetica16-bold' ] 	:= oPrn:DefineFont( 'Helvetica-Bold', 16 ) 
	
    oPrn:hFont[ 'helvetica12' ] 		:= oPrn:DefineFont( 'Helvetica', 12 )  
    oPrn:hFont[ 'helvetica12-bold' ] 	:= oPrn:DefineFont( 'Helvetica-Bold', 12 )  
	
    oPrn:hFont[ 'helvetica10' ] 		:= oPrn:DefineFont( 'Helvetica', 10 )  
    oPrn:hFont[ 'helvetica10-bold' ] 	:= oPrn:DefineFont( 'Helvetica-Bold', 10 ) 	
    
	oPrn:hFont[ 'times-bolditalic'] 	:= oPrn:DefineFont( 'Times-BoldItalic', 10 ) 
	
    oPrn:hFont[ 'helvetica08' ] 		:= oPrn:DefineFont( 'Helvetica', 8 )  
    oPrn:hFont[ 'helvetica08-bold' ] 	:= oPrn:DefineFont( 'Helvetica-Bold', 8 ) 	
 
    oPrn:hFont[ 'title_logo' ] 		:= oPrn:DefineFont( 'Times-Bold', 32 )  
    oPrn:hFont[ 'title_sublogo' ] 		:= oPrn:DefineFont( 'Times-BoldItalic', 16 )

	
   
retu oPrn 

function Commerce( oPrn, h )

	RowCommerce( oPrn, 4.0, "Commerce", h[ 'name'] )
	RowCommerce( oPrn, 4.5, "Address", h[ 'dir1' ] )
	RowCommerce( oPrn, 5.0, "City", h[ 'city' ] )   
	RowCommerce( oPrn, 5.5, "CIF/NIF", h[ 'cif' ] )     
	RowCommerce( oPrn, 6.0, "Contact tlf", h[ 'tlf' ])   
	RowCommerce( oPrn, 6.5, "Contact mail", h[ 'mail' ])   
		
retu nil 


function Client( oPrn, h )

	RowCliente( oPrn, 4.0, "Id.", ltrim(str(h['id_cli'])) )
	RowCliente( oPrn, 4.5, "Bussiness", h[ 'nom_cli' ] )
	RowCliente( oPrn, 5.0, "Name", h[ 'cont_tit' ] + ' ' + h[ 'cont_nom' ] + ' ' + h[ 'cont_ape'] )   
	RowCliente( oPrn, 5.5, "Cargo", h[ 'cont_carg' ] )   
	RowCliente( oPrn, 6.0, "Address", h[ 'dir1' ] + ', ' + h[ 'cp' ])   
	RowCliente( oPrn, 6.5, "City", h[ 'ciudad' ])   
	RowCliente( oPrn, 7.0, "Contact tlf", h[ 'tlf' ])   
	RowCliente( oPrn, 7.5, "Contact mail", h[ 'mail' ])   
		
retu nil 

function LinCol( oPrn, nRow, nCol1, nCol2, cTitle, uValue )
		
	oPrn:cmSay( nRow, nCol1, cTitle, oPrn:hFont[ 'helvetica10' ] ,, 0 )
	oPrn:cmSay( nRow, nCol2, uValue, oPrn:hFont[ 'helvetica10-bold' ] ,, 0 )

retu nil	

function RowCliente( oPrn, nRow, cTitle, uValue )

	oPrn:cmSay( nRow, 12, cTitle, oPrn:hFont[ 'helvetica10' ] ,, 0 )
	oPrn:cmSay( nRow, 15, uValue, oPrn:hFont[ 'helvetica10-bold' ] ,, 0 )

retu nil

function RowCommerce( oPrn, nRow, cTitle, uValue )

	oPrn:cmSay( nRow, 2, cTitle, oPrn:hFont[ 'helvetica10' ] ,, 0 )
	oPrn:cmSay( nRow, 5, uValue, oPrn:hFont[ 'helvetica10-bold' ] ,, 0 )

retu nil
//------------------------------------------------------------------------------

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/controller/print/tpdf.prg" ) %}
	{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}
	