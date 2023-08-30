[![Linux build](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/linux.yml/badge.svg)](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/linux.yml)
[![MacOS build](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/macos.yml/badge.svg)](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/macos.yml)
[![Windows build](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/windows.yml/badge.svg)](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/windows.yml)
[![FreeBSD](https://api.cirrus-ci.com/github/pmqs/Compress-Raw-Bzip2.svg?task=FreeBSD)](https://cirrus-ci.com/github/pmqs/Compress-Raw-Bzip2?task=FreeBSD)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/pmqs/Compress-Raw-Bzip2?svg=true)](https://ci.appveyor.com/project/pmqs/Compress-Raw-Bzip2)


[![Linux + Upstream Sourceware Bzip2 1.0](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/linux-upstream-sourceware.yml/badge.svg)](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/linux-upstream-sourceware.yml)
[![Linux + Upstream GitLab Bzip2 1.1](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/linux-upstream-gitlab.yml/badge.svg)](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/linux-upstream-gitlab.yml)

[![MacOS + Upstream Sourceware Bzip2 1.0](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/macos-upstream-sourceware.yml/badge.svg)](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/macos-upstream-sourceware.yml)
[![MacOS + Upstream GitLab Bzip2 1.1](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/macos-upstream-gitlab.yml/badge.svg)](https://github.com/pmqs/Compress-Raw-Bzip2/actions/workflows/macos-upstream-gitlab.yml)
# NAME

Compress::Raw::Bzip2 - Low-Level Interface to bzip2 compression library

# SYNOPSIS

    use Compress::Raw::Bzip2 ;

    my ($bz, $status) = new Compress::Raw::Bzip2 [OPTS]
        or die "Cannot create bzip2 object: $bzerno\n";

    $status = $bz->bzdeflate($input, $output);
    $status = $bz->bzflush($output);
    $status = $bz->bzclose($output);

    my ($bz, $status) = new Compress::Raw::Bunzip2 [OPTS]
        or die "Cannot create bunzip2 object: $bzerno\n";

    $status = $bz->bzinflate($input, $output);

    my $version = Compress::Raw::Bzip2::bzlibversion();

# DESCRIPTION

`Compress::Raw::Bzip2` provides an interface to the in-memory
compression/uncompression functions from the bzip2 compression library.

Although the primary purpose for the existence of `Compress::Raw::Bzip2`
is for use by the  `IO::Compress::Bzip2` and `IO::Compress::Bunzip2`
modules, it can be used on its own for simple compression/uncompression
tasks.

# Compression

## ($z, $status) = new Compress::Raw::Bzip2 $appendOutput, $blockSize100k, $workfactor;

Creates a new compression object.

If successful, it will return the initialised compression object, `$z`
and a `$status` of `BZ_OK` in a list context. In scalar context it
returns the deflation object, `$z`, only.

If not successful, the returned compression object, `$z`, will be
_undef_ and `$status` will hold the a _bzip2_ error code.

Below is a list of the valid options:

- **$appendOutput**

    Controls whether the compressed data is appended to the output buffer in
    the `bzdeflate`, `bzflush` and `bzclose` methods.

    Defaults to 1.

- **$blockSize100k**

    To quote the bzip2 documentation

        blockSize100k specifies the block size to be used for compression. It
        should be a value between 1 and 9 inclusive, and the actual block size
        used is 100000 x this figure. 9 gives the best compression but takes
        most memory.

    Defaults to 1.

- **$workfactor**

    To quote the bzip2 documentation

        This parameter controls how the compression phase behaves when
        presented with worst case, highly repetitive, input data. If
        compression runs into difficulties caused by repetitive data, the
        library switches from the standard sorting algorithm to a fallback
        algorithm. The fallback is slower than the standard algorithm by
        perhaps a factor of three, but always behaves reasonably, no matter how
        bad the input.

        Lower values of workFactor reduce the amount of effort the standard
        algorithm will expend before resorting to the fallback. You should set
        this parameter carefully; too low, and many inputs will be handled by
        the fallback algorithm and so compress rather slowly, too high, and
        your average-to-worst case compression times can become very large. The
        default value of 30 gives reasonable behaviour over a wide range of
        circumstances.

        Allowable values range from 0 to 250 inclusive. 0 is a special case,
        equivalent to using the default value of 30.

    Defaults to 0.

## $status = $bz->bzdeflate($input, $output);

Reads the contents of `$input`, compresses it and writes the compressed
data to `$output`.

Returns `BZ_RUN_OK` on success and a `bzip2` error code on failure.

If `appendOutput` is enabled in the constructor for the bzip2 object, the
compressed data will be appended to `$output`. If not enabled, `$output`
will be truncated before the compressed data is written to it.

## $status = $bz->bzflush($output);

Flushes any pending compressed data to `$output`.

Returns `BZ_RUN_OK` on success and a `bzip2` error code on failure.

## $status = $bz->bzclose($output);

Terminates the compressed data stream and flushes any pending compressed
data to `$output`.

Returns `BZ_STREAM_END` on success and a `bzip2` error code on failure.

## Example

# Uncompression

## ($z, $status) = new Compress::Raw::Bunzip2 $appendOutput, $consumeInput, $small, $verbosity, $limitOutput;

If successful, it will return the initialised uncompression object, `$z`
and a `$status` of `BZ_OK` in a list context. In scalar context it
returns the deflation object, `$z`, only.

If not successful, the returned uncompression object, `$z`, will be
_undef_ and `$status` will hold the a _bzip2_ error code.

Below is a list of the valid options:

- **$appendOutput**

    Controls whether the compressed data is appended to the output buffer in the
    `bzinflate`, `bzflush` and `bzclose` methods.

    Defaults to 1.

- **$consumeInput**
- **$small**

    To quote the bzip2 documentation

        If small is nonzero, the library will use an alternative decompression
        algorithm which uses less memory but at the cost of decompressing more
        slowly (roughly speaking, half the speed, but the maximum memory
        requirement drops to around 2300k).

    Defaults to 0.

- **$limitOutput**

    The `LimitOutput` option changes the behavior of the `$i->bzinflate`
    method so that the amount of memory used by the output buffer can be
    limited.

    When `LimitOutput` is used the size of the output buffer used will either
    be the 16k or the amount of memory already allocated to `$output`,
    whichever is larger. Predicting the output size available is tricky, so
    don't rely on getting an exact output buffer size.

    When `LimitOutout` is not specified `$i->bzinflate` will use as much
    memory as it takes to write all the uncompressed data it creates by
    uncompressing the input buffer.

    If `LimitOutput` is enabled, the `ConsumeInput` option will also be
    enabled.

    This option defaults to false.

- **$verbosity**

    This parameter is ignored.

    Defaults to 0.

## $status = $z->bzinflate($input, $output);

Uncompresses `$input` and writes the uncompressed data to `$output`.

Returns `BZ_OK` if the uncompression was successful, but the end of the
compressed data stream has not been reached. Returns `BZ_STREAM_END` on
successful uncompression and the end of the compression stream has been
reached.

If `consumeInput` is enabled in the constructor for the bunzip2 object,
`$input` will have all compressed data removed from it after
uncompression. On `BZ_OK` return this will mean that `$input` will be an
empty string; when `BZ_STREAM_END` `$input` will either be an empty
string or will contain whatever data immediately followed the compressed
data stream.

If `appendOutput` is enabled in the constructor for the bunzip2 object,
the uncompressed data will be appended to `$output`. If not enabled,
`$output` will be truncated before the uncompressed data is written to it.

# Misc

## my $version = Compress::Raw::Bzip2::bzlibversion();

Returns the version of the underlying bzip2 library.

# Constants

The following bzip2 constants are exported by this module

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

# SUPPORT

General feedback/questions/bug reports should be sent to
[https://github.com/pmqs/Compress-Raw-Bzip2/issues](https://github.com/pmqs/Compress-Raw-Bzip2/issues) (preferred) or
[https://rt.cpan.org/Public/Dist/Display.html?Name=Compress-Raw-Bzip2](https://rt.cpan.org/Public/Dist/Display.html?Name=Compress-Raw-Bzip2).

# SEE ALSO

[Compress::Zlib](https://metacpan.org/pod/Compress%3A%3AZlib), [IO::Compress::Gzip](https://metacpan.org/pod/IO%3A%3ACompress%3A%3AGzip), [IO::Uncompress::Gunzip](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AGunzip), [IO::Compress::Deflate](https://metacpan.org/pod/IO%3A%3ACompress%3A%3ADeflate), [IO::Uncompress::Inflate](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AInflate), [IO::Compress::RawDeflate](https://metacpan.org/pod/IO%3A%3ACompress%3A%3ARawDeflate), [IO::Uncompress::RawInflate](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3ARawInflate), [IO::Compress::Bzip2](https://metacpan.org/pod/IO%3A%3ACompress%3A%3ABzip2), [IO::Uncompress::Bunzip2](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3ABunzip2), [IO::Compress::Lzma](https://metacpan.org/pod/IO%3A%3ACompress%3A%3ALzma), [IO::Uncompress::UnLzma](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AUnLzma), [IO::Compress::Xz](https://metacpan.org/pod/IO%3A%3ACompress%3A%3AXz), [IO::Uncompress::UnXz](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AUnXz), [IO::Compress::Lzip](https://metacpan.org/pod/IO%3A%3ACompress%3A%3ALzip), [IO::Uncompress::UnLzip](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AUnLzip), [IO::Compress::Lzop](https://metacpan.org/pod/IO%3A%3ACompress%3A%3ALzop), [IO::Uncompress::UnLzop](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AUnLzop), [IO::Compress::Lzf](https://metacpan.org/pod/IO%3A%3ACompress%3A%3ALzf), [IO::Uncompress::UnLzf](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AUnLzf), [IO::Compress::Zstd](https://metacpan.org/pod/IO%3A%3ACompress%3A%3AZstd), [IO::Uncompress::UnZstd](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AUnZstd), [IO::Uncompress::AnyInflate](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AAnyInflate), [IO::Uncompress::AnyUncompress](https://metacpan.org/pod/IO%3A%3AUncompress%3A%3AAnyUncompress)

[IO::Compress::FAQ](https://metacpan.org/pod/IO%3A%3ACompress%3A%3AFAQ)

[File::GlobMapper](https://metacpan.org/pod/File%3A%3AGlobMapper), [Archive::Zip](https://metacpan.org/pod/Archive%3A%3AZip),
[Archive::Tar](https://metacpan.org/pod/Archive%3A%3ATar),
[IO::Zlib](https://metacpan.org/pod/IO%3A%3AZlib)

The primary site for the bzip2 program is [https://sourceware.org/bzip2/](https://sourceware.org/bzip2/).

See the module [Compress::Bzip2](https://metacpan.org/pod/Compress%3A%3ABzip2)

# AUTHOR

This module was written by Paul Marquess, `pmqs@cpan.org`.

# MODIFICATION HISTORY

See the Changes file.

# COPYRIGHT AND LICENSE

Copyright (c) 2005-2023 Paul Marquess. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
