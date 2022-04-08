//----------------------------------------------------------------------------//

CLASS DbfCdxProvider 

	DATA cAlias	
	DATA cId
	DATA oDataset	
	DATA hSearch 					INIT {=>}
	DATA lCanLoadAll				INIT .t.
	DATA nMax						INIT 1000
	
	DATA bLoadRow 					
	
	METHOD New()             		CONSTRUCTOR	
	
	METHOD Open() 
	
	METHOD GetId()
	METHOD GetAll()
	METHOD Search()
	METHOD SearchExact( cKey_Search, uValue )
	
	METHOD Count()					INLINE (::cAlias)->( RecCount() )
	METHOD CountId()						

ENDCLASS 

//----------------------------------------------------------------------------//

METHOD New() CLASS DbfCdxProvider


RETU SELF

//----------------------------------------------------------------------------//

METHOD Open( cDbf, cCdx ) CLASS DbfCdxProvider

	USE ( cDbf ) SHARED NEW VIA 'DBFCDX' ALIAS (NewAlias())
	SET INDEX TO ( cCdx )
	
	::cAlias 	:= Alias()
	
	::bLoadRow := {|| ::oDataset:Row() }
	

RETU SELF
//----------------------------------------------------------------------------//


METHOD GetId( uValue ) CLASS DbfCdxProvider

	local hRow	:= {=>}	
	local n 		:= 0
	local uSearch	:= ''
	local nPos 
	local cType

_d( 'Alias:' + ::cAlias )	
_d( 'Id:' + ::cId )	

	if !HB_HHasKey( ::hSearch, ::cId ) 		
		mh_DoError( 'Index not defined -> ' + procname(0) )
		retu nil
	endif 
	

	aInfo 		:= ::hSearch[ ::cId ]
	
	if len( aInfo ) == 1
		mh_DoError( 'Field search not defined -> ' + procname(0) )
		retu nil
	endif 	

	
	cTag 		:= aInfo[1]
	nPos 		:= (::cAlias)->( FieldPos( aInfo[2] ) )
	cType 		:= valtype( (::cAlias)->( FieldGet(nPos)) )
	
_d( 'Tag:' + cTag )	
_d( 'Pos:', nPos )	
_d( 'Type:', cType )	
	
	bPrepare 	:= if( len( aInfo ) > 2 , aInfo[3], nil )	

	if valtype( bPrepare ) == 'B' 
		uSearch := Eval( bPrepare, uValue )
	else
		uSearch := uValue
	endif	
	
_d( 'GETID SEARCH', uSearch )	

		
	(::cAlias)->( OrdSetFocus( cTag ) )
	(::cAlias)->( dbGoTop() )
	(::cAlias)->( dbSeek( uSearch, .f. ) )
	
	IF ( ::cAlias )->( FieldGet( nPos ) ) == uValue
	
		//Aadd( hRow, eval( ::bLoadRow )  )					
		hRow := eval( ::bLoadRow )  	

	endif
	
_d( hRow )	
	
retu hRow 

//----------------------------------------------------------------------------//

METHOD GetAll(  ) CLASS DbfCdxProvider

	local aRows	:= {}
	local n 		:= 0
	
	
		
	(::cAlias)->( OrdSetFocus( ::cId ) )
	(::cAlias)->( DbGoTop() )

		while n <= ::nMax .and. (::cAlias)->( !eof() )									
		
			Aadd( aRows, eval( ::bLoadRow ) )	

			(::cAlias)->( DbSkip() )			
			
			n++
		end

RETU aRows

//----------------------------------------------------------------------------//


METHOD Search( cKey_Search, cSearch ) CLASS DbfCdxProvider

	local aRows	:= {}	
	local n 		:= 0
_d( 'SEARCH....' )
	if empty( cSearch )
		retu if( ::lCanLoadAll, ::GetAll(), aRows )
	endif
	
	cKey_Search := lower( cKey_Search )
	

	if ! HB_HHasKey( ::hSearch, cKey_Search )		
		retu aRows
	endif 
	
	aInfo 		:= ::hSearch[ cKey_Search ]
	
	cTag 		:= aInfo[1]
	
	bPrepare 	:= if( len( aInfo ) > 2 , aInfo[3], nil )
	

	if valtype( bPrepare ) == 'B' 
		cSearch := Eval( bPrepare, cSearch )
	endif	
	
_d( 'Alias:' + ::cAlias )	
_d( 'Tag:' + cTag )	
_d( 'Search:' + cSearch )	
		
	(::cAlias)->( OrdSetFocus( cTag ) )
	(::cAlias)->( dbGoTop() )
	
	while (::cAlias)->( OrdWildSeek(  "*" + cSearch + '*', .t. ) ) .or. ;
		   (::cAlias)->( OrdWildSeek(  cSearch + '*', .t. ) ) .or. ; 
			(::cAlias)->( OrdWildSeek(  '*' + cSearch , .t. ) ) .and. ;
			 n <= ::nMax 
						
	
		Aadd( aRows, eval( ::bLoadRow )  )			
		
		n++

	end	
	
retu aRows



METHOD SearchExact( cKey_Search, uValue ) CLASS DbfCdxProvider

	local aRows	:= {}	
	local n 		:= 0
	
_d( 'SEARCHEXACT....' )

	if empty( uValue )
		retu aRows 
	endif
	
	cKey_Search := lower( cKey_Search )
	

	if ! HB_HHasKey( ::hSearch, cKey_Search )		
		retu aRows
	endif 
	
	aInfo 		:= ::hSearch[ cKey_Search ]	
	cTag 		:= aInfo[1]
	nPos 		:= (::cAlias)->( FieldPos( aInfo[2] ) )
	cType 		:= valtype( (::cAlias)->( FieldGet(nPos)) )
	
_d( 'Tag:' + cTag )	
_d( 'Pos:', nPos )	
_d( 'Type:', cType )	
	
	bPrepare 	:= if( len( aInfo ) > 2 , aInfo[3], nil )	

	if valtype( bPrepare ) == 'B' 
		uSearch := Eval( bPrepare, uValue )
	else
		uSearch := uValue
	endif	
	
_d( 'SEARCH', uSearch )	

		
	(::cAlias)->( OrdSetFocus( cTag ) )
	(::cAlias)->( dbGoTop() )
	(::cAlias)->( dbSeek( uSearch, .f. ) )
	
	while ( ::cAlias )->( FieldGet( nPos ) ) == uValue .and. (::cAlias)->( !eof() )
	
		Aadd( aRows, eval( ::bLoadRow ) )	

		(::cAlias)->( DbSkip() )

	end 
	
retu aRows


//----------------------------------------------------------------------------//

METHOD CountId( cKey, uValue ) CLASS DbfCdxProvider

	local nTotal := 0
	local cField, nFieldPos, bPrepare
_d( 'COUNTID ' + cKey  )
	if HB_HHasKey( ::hSearch, cKey )
	
		cTag 		:= ::hSearch[ cKey ][1] 
		cField 		:= ::hSearch[ cKey ][2] 
		nFieldPos 	:= (::cAlias)->( FieldPos( cField) )
		
		bPrepare 	:= if( len( ::hSearch[ cKey ] ) > 2 , ::hSearch[ cKey ][3], nil )	

		if valtype( bPrepare ) == 'B' 
			uValue := Eval( bPrepare, uValue )
		endif							
		
		(::cAlias)->( OrdSetFocus( cTag ) )
		
		(::cAlias)->( DbSeek( uValue) )
		
		while (::cAlias)->( FieldGet( nFieldPos ) ) == uValue .and. (::cAlias)->( !eof())
		
			nTotal++
		
			(::cAlias)->( dbskip() )
		end 								
		
	endif



RETU nTotal 

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

function NewAlias( cPrefix ) 

   local cAlias
   local nAliasNo := 0

   DEFAULT cPrefix   	TO "tmp"
   
   cPrefix := Left( cPrefix, 3 )

   do while Select( cAlias := cPrefix + StrZero( ++nAliasNo, 5 ) ) > 0
   enddo
   
return cAlias

