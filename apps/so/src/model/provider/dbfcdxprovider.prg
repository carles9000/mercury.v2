//----------------------------------------------------------------------------//

CLASS DbfCdxProvider 

	DATA cAlias	
	DATA cId
	DATA oDataset	
	DATA hSearch 					INIT {=>}
	DATA lCanLoadAll				INIT .t.
	DATA nMax						INIT 1000
	
	METHOD New()             		CONSTRUCTOR	
	
	METHOD Open() 
	
	METHOD GetAll()
	METHOD Search()
	METHOD Count()					INLINE (::cAlias)->( RecCount() )
	
	

ENDCLASS 

//----------------------------------------------------------------------------//

METHOD New() CLASS DbfCdxProvider


RETU SELF

//----------------------------------------------------------------------------//

METHOD Open( cDbf, cCdx ) CLASS DbfCdxProvider

	//USE ( AppPathData() + 'producto.dbf' ) SHARED NEW VIA 'DBFCDX'
	//SET INDEX TO )'producto.cdx'
	USE ( cDbf ) SHARED NEW VIA 'DBFCDX'
	SET INDEX TO ( cCdx )
	
	::cAlias 	:= Alias()
	

RETU SELF

//----------------------------------------------------------------------------//

METHOD GetAll() CLASS DbfCdxProvider

	local aRows	:= {}
	local n 		:= 0
		
	(::cAlias)->( OrdSetFocus( ::cId ) )
	(::cAlias)->( DbGoTop() )

		while n <= ::nMax .and. (::cAlias)->( !eof() )									
		
			Aadd( aRows, ::oDataset:Row() )	

			(::cAlias)->( DbSkip() )			
			
			n++
		end

RETU aRows

//----------------------------------------------------------------------------//


METHOD Search( cKey_Search, cSearch ) CLASS DbfCdxProvider

	local aRows	:= {}	
	local n 		:= 0

	if empty( cSearch )
		retu if( ::lCanLoadAll, ::GetAll(), aRows )
	endif
	
	cKey_Search := lower( cKey_Search )
	

	if ! HB_HHasKey( ::hSearch, cKey_Search )		
		retu aRows
	endif 
	
	aInfo 		:= ::hSearch[ cKey_Search ]
	
	cTag 		:= aInfo[1]
	
	bPrepare 	:= if( len( aInfo ) > 1 , aInfo[2], nil )
	

	if valtype( bPrepare ) == 'B' 
		cSearch := Eval( bPrepare, cSearch )
	endif	
	
//_d( 'Tag:' + cTag )	
//_d( 'Search:' + cSearch )	
		
	(::cAlias)->( OrdSetFocus( cTag ) )
	(::cAlias)->( dbGoTop() )
	
	while (::cAlias)->( OrdWildSeek(  "*" + cSearch + '*', .t. ) ) .or. ;
		   (::cAlias)->( OrdWildSeek(  cSearch + '*', .t. ) ) .or. ; 
			(::cAlias)->( OrdWildSeek(  '*' + cSearch , .t. ) ) .and. ;
			 n <= ::nMax 
						
	
		Aadd( aRows, ::oDataset:Row() )			
		
		n++

	end	
	
retu aRows



//	-----------------------------------------------
/*

Static function IsMatch( aMask, cFileName )
   LOCAL lMatch := .f., cMask
   for each cMask in aMask
      if hb_WildMatch( cMask, cFileName, .t. )
         lMatch := .t.
         exit
      endif
   next
Return lMatch
*/

//	-----------------------------------------------


