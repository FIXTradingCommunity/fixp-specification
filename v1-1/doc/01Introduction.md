# Scope

FIX Performance Session Layer (FIXP) is a “lightweight point-to-point protocol” introduced to provide an open industry standard for high performance computing requirements currently encountered by the FIX Community. FIXP is a derived work. The origin and basis for FIXP are the FIX session layer protocols and protocols designed and implemented by NASDAQ OMX, i.e. SoupTCP, SoupBinTCP, and UFO (UDP for Orders). Every attempt was made to keep FIXP as close to the functionality and behavior of SoupBinTCP and UFO as possible. Extensions and refactoring were performed as incremental improvements. Every attempt was made to limit FIXP to establishing and maintaining a communication session between two end points in a reliable manner, regardless of the reliability of the underlying transport.

FIXP features:

- Very lightweight session layer with no restrictions on the application layer
- Encoding independent supporting binary protocols
- Transport independent supporting both stream, datagram, and message oriented protocols
- Point-to-point as well as multicast patterns, sharing common primitives
- Negotiable delivery guarantees that may be asymmetrical

# Normative references

The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.

### Related FIX standards

The FIX Simple Open Framing Header standard governs how messages are delimited and has a specific relationship mentioned in this specification. FIXP interoperates with the other FIX standards at the application and presentation layers, but it is not dependent on them. Therefore, they are considered non-normative for FIXP.

[Simple Open Framing Header (SOFH)](https://www.fixtrading.org/standards/fix-sofh/), technical specification of a message framing standard for FIX messages.

[FIX Latest](https://www.fixtrading.org/online-specification/), normative specification of the application layer of the FIX protocol.

[FIX Simple Binary Encoding](https://www.fixtrading.org/standards/sbe/), optional specification for the presentation layer of the FIX protocol.

[Abstract Syntax Notation (ASN.1)](https://www.fixtrading.org/standards/asn1/), optional specification for the presentation layer of the FIX protocol.

[Google Protocol Buffers(GPB)](https://www.fixtrading.org/standards/gpb/), optional specification for the presentation layer of the FIX protocol.

[FIX-over-TLS (FIXS)](https://www.fixtrading.org/standards/fixs-online/), security guidelines for using Transport Layer Security (TLS) with FIX.

### Dependencies on other standards

FIXP is dependent on several industry standards. Implementations of FIXP must conform to these standards to interoperate. Therefore, they are normative for FIXP. Other protocols may be used by agreement between counterparties.

[IEEE 754-2019](https://ieeexplore.ieee.org/document/8766229), *IEEE Standard for Binary Floating-Point Arithmetic*

[IETF RFC 793](https://tools.ietf.org/html/rfc793), *Transmission Control Protocol (TCP)*

[IETF RFC 768](https://tools.ietf.org/html/rfc768), *User Datagram Protocol (UDP)*

[IETF RFC 4122](https://tools.ietf.org/html/rfc4122), *A Universally Unique IDentifier (UUID) URN Namespace* 

[IETF RFC 3629](https://tools.ietf.org/html/rfc3629), *UTF-8, a transformation format of ISO 10646* 

[IETF RFC 6455](https://tools.ietf.org/html/rfc6455), *The WebSocket Protocol* 

# Terms and definitions

For the purposes of this document, the terms and definitions given in [Internet Engineering Task Force RFC2119](http://www.apps.ietf.org/rfc/rfc2119.html) and the following apply.

ISO and IEC maintain terminology databases for use in standardization at the following addresses:

--- ISO Online browsing platform: available at [https://www.iso.org/obp](https://www.iso.org/obp)

--- IEC Electropedia: available at [https://www.electropedia.org](https://www.electropedia.org)

### session
A dialog for exchanging application messages between peers. An established point-to-point session consists of a pair of flows, one in each direction between peers. A multicast session consists of a single flow from the producer to multiple consumers.

### flow
A unidirectional stream of messages. Each flow has one producer and one or more consumers.

### multicast
A method of sending datagrams from one producer to multiple consumers.

### client
Initiator of session.

### server
Acceptor of session.

### credentials 
User identification for authentication.

### idempotence 
Idempotence means that an operation that is applied multiple times does not change the outcome, the result, after the first time.

### IETF
Internet Engineering Task Force.

### TCP
Transmission Control Protocol is a set of IETF standards for a reliable stream of data exchanged between peers. Since it is connection oriented, it incorporates some features of a session protocol.

### TLS
Transport Layer Security is a set of IETF standards to provide security to a session. TLS is a successor to Secure Sockets Layer (SSL).

### UDP
User Datagram Protocol is a connectionless transmission for delivering packets of data. Any rules for a long-lived exchange of messages must be supplied by a session protocol.

### WebSocket
An IETF protocol that consists of an opening handshake followed by basic message framing, layered over TCP. May be used with TLS.

## Specification terms

These key words in this document are to be interpreted as described in
[Internet Engineering Task Force RFC2119](http://www.apps.ietf.org/rfc/rfc2119.html). 

These terms indicate an absolute requirement for implementations of the standard: "**must**", or "**required**".

This term indicates an absolute prohibition: "**must not**".

These terms indicate that a feature is allowed by the standard but not
required: "**may**", "**optional**". An implementation that does not
provide an optional feature must be prepared to interoperate with one
that does.

These terms give guidance, recommendation or best practices:
"**should**" or "**recommended**". A recommended choice among
alternatives is described as "**preferred**".

These terms give guidance that a practice is not recommended: "**should not**"
or "**not recommended**".
