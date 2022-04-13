#include {% TWebInclude() %}


CLASS PedidoPosModel  FROM DbfCdxProvider

	DATA oProd

	METHOD New()             		CONSTRUCTOR

	METHOD LoadPos( nId_Ped )
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS PedidoPosModel

	::Open( AppPathData() + 'ped_pos.dbf', AppPathData() + 'ped_pos.cdx')
	

	//	Define data Dataset. These will be the only fields that I will allow to work
	
	DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

		FIELD 'id' 			UPDATE  OF ::oDataset
		FIELD 'id_ped' 		UPDATE  OF ::oDataset
		FIELD 'id_prod'		UPDATE  OF ::oDataset
		FIELD 'precio'		UPDATE  OF ::oDataset
		FIELD 'ctd'			UPDATE  OF ::oDataset
		FIELD 'total'		CALCULATED {|cAlias| (cAlias)->precio * (cAlias)->ctd  } OF ::oDataset

		
	//	Define if can Loading all records...  (for small tables)
	
		::lCanLoadAll := .F. 
	
	//	Define main tag cdx index

		::cId 		:= 'id'
	
	//	Define Searchs by Tag 
	
		::hSearch[ 'id' ] 		:= { 'id', 'id' }
		::hSearch[ 'id_ped' ]	:= { 'id_ped', 'id_ped' }
		::hSearch[ 'id_prod' ]	:= { 'id_prod', 'id_prod' }
	
	//	
		(::cAlias)->( OrdSetFocus( ::hSearch[ 'id' ][1] ) )


	//	---------------------------------
	
		::oProd  	:= ProdModel():New()
		

RETU SELF


//----------------------------------------------------------------------------//

METHOD LoadPos( nId_Ped ) CLASS PedidoPosModel

	local aPos := {}
	
	(::cAlias)->( OrdSetFocus( ::hSearch[ 'id_ped' ][1] ) )
	
	(::cAlias)->( DbSeek( nId_Ped ) )


_d( 'LOADPOS', nId_Ped )	
	while (::cAlias)->id_ped == nId_Ped .and. (::cAlias)->( !eof() )
	
_d( 'LOADPOS-a' )	
	
		//	LEFT JOIN Producto	---------------------------------------	
		
		cProd := ''
		
		if !empty( (::cAlias)->id_prod )

			h := ::oProd:GetId( (::cAlias)->id_prod ) 

			if len(h) > 0
			
				cProd := h[ 'nombre' ]
		
			endif
			
		endif 
		
		h := ::oDataset:Row() 
		h[ 'prod_txt'] := cProd 
		
		Aadd( aPos, h )
	/*
		Aadd( aPos, { 'id' => (::cAlias)->id,;
						'id_ped' => (::cAlias)->id_ped,;
						'id_prod' => (::cAlias)->id_prod,;
						'prod_txt' => cProd,;
						'precio' => (::cAlias)->precio,;
						'ctd' => (::cAlias)->ctd;
					})
	*/
	
	
		(::cAlias)->( DbSkip() )
	end  


RETU aPos 

//----------------------------------------------------------------------------//

{% mh_LoadFile( "/src/model/provider/dbfcdxprovider.prg" ) %}
{% mh_LoadFile( "/src/model/prodmodel.prg" ) %}
