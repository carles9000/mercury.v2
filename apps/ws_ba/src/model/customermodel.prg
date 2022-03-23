CLASS CustomerModel 

	DATA cAlias	

	METHOD New()             		CONSTRUCTOR

	METHOD GetZip( cZip , hData )
	METHOD RowsByState( cState )
	METHOD Count()					INLINE (::cAlias)->( RecCount() )
	METHOD Load()					
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS CustomerModel

	USE ( AppPathData() + 'test.dbf' ) SHARED NEW VIA 'DBFCDX'
	SET INDEX TO 'test.cdx'
	
	::cAlias := Alias()	

RETU SELF


//	-----------------------------------------------

METHOD GetZip( cZip , hData ) CLASS CustomerModel

	local lFound	:= .f.
	
	DEFAULT cZip TO  ''
	
	(::cAlias)->( OrdSetFocus( 'zip' ) )
	(::cAlias)->( DbSeek( cZip, .F. ) )
	
	hData := ::Load()
	
	lFound := (::cAlias)->zip == cZip 

	if ! lFound	
		hData[ '_recno' ] 	:= 0
		hData[ 'zip' ] 		:= cZip 
	endif
	
RETU lFound

//	-----------------------------------------------

METHOD RowsByState( cState ) CLASS CustomerModel

	local aRows	:= {}	
	
	DEFAULT cState TO  ''
	
	(::cAlias)->( OrdSetFocus( 'state' ) )
	(::cAlias)->( DbSeek( cState ) )
	
	while (::cAlias)->state == cState .and. (::cAlias)->( ! Eof() )
	
		Aadd( aRows , ::Load() )
						
		(::cAlias)->( DbSkip() )
	end
	
RETU aRows

//	-----------------------------------------------

METHOD Load() CLASS CustomerModel

	local hRow := {'_recno'		=> (::cAlias)->( Recno()),;
					'first'		=> (::cAlias)->first ,;
					'last'		=> (::cAlias)->last ,;
					'street'	=> (::cAlias)->street ,;
					'city'		=> (::cAlias)->city ,;
					'state'		=> (::cAlias)->state ,;
					'zip'		=> (::cAlias)->zip ,;
					'hiredate'	=> (::cAlias)->hiredate,;
					'married'	=> (::cAlias)->married,;
					'age'		=> (::cAlias)->age,;
					'salary'	=> (::cAlias)->salary,;
					'notes'		=> (::cAlias)->notes  ;											
					}
	
RETU hRow

//	-----------------------------------------------


