# fixp-specification
This project contains specifications and resources for FIX Performance session layer (FIXP).


## Protocol stack
FIXP is part of a family of protocols created by the High Performance Working Group
 of the FIX Trading Community. FIXP is a session layer protocol (layer 5).

## Versions

The planned lifecycle of this project is to work iteratively in a series of release candidates. After each release candidate is approved, it will be exposed to public review. Issues may be entered here in GitHub or in a discussion forum on the FIX Trading Community site. When a version is considered complete, the last release candidate will be promoted to Draft Standard.

Promotion to final Technical Standard is contingent on successful public review and evidence of at least two interoperable implementations.

All approved versions of the FIXP specification are available as MS Word documents at [FIX Performance Session Layer (FIXP)](https://www.fixtrading.org/standards/fixp/).

### Version 1.1 Draft Standard

Version 1.1 was approved for publication by the Global Technical Committee on April 18, 2019. A guideline for using FIXP over Websocket transport has been added to the specification. Comments may be entered in the FIX discussion forum (https://forum.fixtrading.org/). Pull requests and issues may be entered in this GitHub project for errata or proposed enhancements. 

### Version 1.0 Draft Standard
Version 1.0 Draft Standard was approved for publication by the Global Technical Committee on August 16, 2018 for public review. Comments may be entered in the FIX public forum. Pull requests will only be accepted for errata.

Version 1.0 RC4 and earlier specifications are included here for reference only.

## License
FIXP specifications are © Copyright 2014-2019 FIX Protocol Ltd.

<a rel="license" href="http://creativecommons.org/licenses/by-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nd/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">FIX Performance Session Layer specification</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.fixtradingcommunity.org/" property="cc:attributionName" rel="cc:attributionURL">FIX Protocol Ltd.</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nd/4.0/">Creative Commons Attribution-NoDerivatives 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/FIXTradingCommunity/fixp-specification" rel="dct:source">https://github.com/FIXTradingCommunity/fixp-specification</a>.

## Implementations

We will post links to open source implementations of FIXP. Implementors, contact one
of the owners of this repository.

### Reference Implementation: silverflash
An open-source implementation of FIXP is available in GitHub project [FIXTradingCommunity/silverflash](https://github.com/FIXTradingCommunity/silverflash). That project also demonstrates FIX standards Simple Binary Encoding (SBE) and Simple Open Framing Header (SOFH).

### Project Conga
[Project Conga](https://github.com/FIXTradingCommunity/conga) is a proof of concept of high performance FIX semantics over WebSocket with SBE and JSON encodings. At the session layer, it employs FIXP for session durability, reliability, and recoverability.
