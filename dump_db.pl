#!/usr/bin/perl

$dumpname = "pgdump.txt";
for ( $i = 5; $i >= 1; $i-- ) {
    $new = sprintf( "$dumpname.%d", $i );
    if ( $i > 1 ) {
        $old = sprintf( "$dumpname.%d", $i-1 );
    } else {
        $old = $dumpname;
    }
    if ( stat( $old )) {
        system( "mv $old $new" );
    }
}
system( "pg_dumpall > $dumpname" );
