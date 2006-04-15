
package Compress::Raw::Bzip2;

use strict ;
use warnings ;

require 5.004 ;
require Exporter;
use AutoLoader;
use Carp ;

use bytes ;
our ($VERSION, $XS_VERSION, @ISA, @EXPORT, $AUTOLOAD);

$VERSION = '2.000_11';
$XS_VERSION = $VERSION; 
$VERSION = eval $VERSION;

@ISA = qw(Exporter);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
		BZ_RUN
		BZ_FLUSH
		BZ_FINISH

		BZ_OK
		BZ_RUN_OK
		BZ_FLUSH_OK
		BZ_FINISH_OK
		BZ_STREAM_END
		BZ_SEQUENCE_ERROR
		BZ_PARAM_ERROR
		BZ_MEM_ERROR
		BZ_DATA_ERROR
		BZ_DATA_ERROR_MAGIC
		BZ_IO_ERROR
		BZ_UNEXPECTED_EOF
		BZ_OUTBUFF_FULL
		BZ_CONFIG_ERROR

    );

sub AUTOLOAD {
    my($constname);
    ($constname = $AUTOLOAD) =~ s/.*:://;
    my ($error, $val) = constant($constname);
    Carp::croak $error if $error;
    no strict 'refs';
    *{$AUTOLOAD} = sub { $val };
    goto &{$AUTOLOAD};
}

use constant FLAG_APPEND             => 1 ;
use constant FLAG_CRC                => 2 ;
use constant FLAG_ADLER              => 4 ;
use constant FLAG_CONSUME_INPUT      => 8 ;

eval {
    require XSLoader;
    XSLoader::load('Compress::Raw::Bzip2', $XS_VERSION);
    1;
} 
or do {
    require DynaLoader;
    local @ISA = qw(DynaLoader);
    bootstrap Compress::Raw::Bzip2 $XS_VERSION ; 
};

sub Compress::Raw::Bzip2::new
{
    my $class = shift ;
    my ($ptr, $status) = _new(@_);
    return wantarray ? (undef, $status) : undef
        unless $ptr ;
    my $obj = bless [$ptr], $class ;
    return wantarray ? ($obj, $status) : $obj;
}

package Compress::Raw::Bunzip2 ;

sub Compress::Raw::Bunzip2::new
{
    my $class = shift ;
    my ($ptr, $status) = _new(@_);
    return wantarray ? (undef, $status) : undef
        unless $ptr ;
    my $obj = bless [$ptr], $class ;
    return wantarray ? ($obj, $status) : $obj;
}

package Compress::Raw::Bzip2;

1;

__END__


=head1 NAME

Compress::Raw::Bzip2 - Low-Level Interface to bzip2 compression library

=head1 SYNOPSIS

    use Compress::Raw::Bzip2 ;

=head1 DESCRIPTION

C<Compress::Raw::Bzip2> provides the interface to the bzip2 library for the
modules C<IO::Compress::Bzip2> and C<IO::Compress::Bunzip2>.

More documentation to follow.


=head1 SEE ALSO

L<Compress::Zlib>, L<IO::Compress::Gzip>, L<IO::Uncompress::Gunzip>, L<IO::Compress::Deflate>, L<IO::Uncompress::Inflate>, L<IO::Compress::RawDeflate>, L<IO::Uncompress::RawInflate>, L<IO::Compress::Bzip2>, L<IO::Uncompress::Bunzip2>, L<IO::Compress::Lzop>, L<IO::Uncompress::UnLzop>, L<IO::Uncompress::AnyInflate>, L<IO::Uncompress::AnyUncompress>

L<Compress::Zlib::FAQ|Compress::Zlib::FAQ>

L<File::GlobMapper|File::GlobMapper>, L<Archive::Zip|Archive::Zip>,
L<Archive::Tar|Archive::Tar>,
L<IO::Zlib|IO::Zlib>



The primary site for the bzip2 program is F<http://www.bzip.org>.

See the module L<Compress::Bzip2|Compress::Bzip2>



=head1 AUTHOR

This module was written by Paul Marquess, F<pmqs@cpan.org>. 



=head1 MODIFICATION HISTORY

See the Changes file.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2005-2006 Paul Marquess. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.



