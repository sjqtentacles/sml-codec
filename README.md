# sml-codec

[![CI](https://github.com/sjqtentacles/sml-codec/actions/workflows/ci.yml/badge.svg)](https://github.com/sjqtentacles/sml-codec/actions/workflows/ci.yml)

Pure binary codecs and hashes for Standard ML: Base16, Base64, CRC-32,
SHA-1, and SHA-256.

`sml-codec` is the byte-twiddling foundation of the web stack -- the pieces
needed to compute a WebSocket accept key, sign a cookie (via `sml-crypto`),
checksum a gzip member, or encode binary data for transport. Everything is
pure Standard ML over the Basis library, with no dependencies.

Verified against the published RFC test vectors on **MLton** and **Poly/ML**;
the suite produces byte-for-byte identical output across both.

## Modules

| Structure | Spec | Highlights |
| --- | --- | --- |
| `Base16` | RFC 4648 | lower/upper hex encode, case-insensitive decode |
| `Base64` | RFC 4648 | standard + URL-safe alphabets, padding-tolerant decode |
| `Crc32`  | ISO 3309 | reflected poly `0xEDB88320`, `crc`/`crcHex` |
| `Sha1`   | RFC 3174 | `digest` (20 raw bytes) + `hexDigest` |
| `Sha256` | RFC 6234 | `digest` (32 raw bytes) + `hexDigest` |

## API

```sml
structure Base16 : sig
  val encode : string -> string         (* lowercase hex *)
  val encodeUpper : string -> string
  val decode : string -> string option  (* NONE on odd length / non-hex *)
end

structure Base64 : sig
  val encode : string -> string          (* standard, '=' padded *)
  val encodeUrl : string -> string       (* URL-safe, no padding *)
  val decode : string -> string option
end

structure Crc32 : sig
  val crc : string -> Word32.word
  val crcHex : string -> string          (* 8 lowercase hex digits *)
end

structure Sha1 : sig
  val digest : string -> string          (* 20 raw bytes *)
  val hexDigest : string -> string       (* 40 hex chars *)
end

structure Sha256 : sig
  val digest : string -> string          (* 32 raw bytes *)
  val hexDigest : string -> string       (* 64 hex chars *)
end
```

### Example

```sml
val () = print (Base64.encode "foobar" ^ "\n")            (* Zm9vYmFy *)
val () = print (Sha256.hexDigest "abc" ^ "\n")
(* ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad *)
val () = print (Crc32.crcHex "123456789" ^ "\n")          (* cbf43926 *)
```

## Build & test

Requires [MLton](http://mlton.org/) and/or [Poly/ML](https://polyml.org/).

```sh
make test        # build + run the suite under MLton
make test-poly   # run the suite under Poly/ML
make all-tests   # both
make clean
```

## Installing with smlpkg

```sh
smlpkg add github.com/sjqtentacles/sml-codec
smlpkg sync
```

Reference `lib/github.com/sjqtentacles/sml-codec/sml-codec.mlb` from your own
`.mlb` (MLton / MLKit), or feed `sources.mlb` to `tools/polybuild` (Poly/ML).

## Layout

```
sml.pkg                                       smlpkg manifest
Makefile                                      MLton + Poly/ML targets
.github/workflows/ci.yml                      CI: MLton + Poly/ML
lib/github.com/sjqtentacles/sml-codec/
  base16.sig/.sml  hex
  base64.sig/.sml  base64 (+ url-safe)
  crc32.sig/.sml   CRC-32
  sha1.sig/.sml    SHA-1
  sha256.sig/.sml  SHA-256
  sources.mlb      ordered source list
  sml-codec.mlb    public basis
test/
  harness.sml  shared assertion harness
  test.sml     RFC-vector suite (35 checks)
  entry.sml / main.sml
tools/polybuild  Poly/ML build wrapper
```

## Tests

35 deterministic checks against the RFC 4648 (Base16/Base64), RFC 3174
(SHA-1, including the one-million-`a` vector), RFC 6234 (SHA-256), and
standard CRC-32 (`crc32("123456789") = 0xCBF43926`) vectors. Run
`make all-tests` to verify identical output under both compilers.

## License

MIT. See [LICENSE](LICENSE).
