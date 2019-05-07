Introduction
============

FIX Performance Session Layer (FIXP) is a “lightweight point-to-point protocol” introduced to provide an open industry standard for high performance computing requirements currently encountered by the FIX Community. FIXP is a derived work. The origin and basis for FIXP are the FIX session layer protocols and protocols designed and implemented by NASDAQ OMX, i.e. SoupTCP, SoupBinTCP, and UFO (UDP for Orders). Every attempt was made to keep FIXP as close to the functionality and behavior of SoupBinTCP and UFO as possible. Extensions and refactoring were performed as incremental improvements. Every attempt was made to limit FIXP to establishing and maintaining a communication session between two end points in a reliable manner, regardless of the reliability of the underlying transport.

## FIXP features

- Very lightweight session layer with no restrictions on the application layer
- Encoding independent supporting binary protocols
- Transport independent supporting both stream, datagram, and message oriented protocols
- Point-to-point as well as multicast patterns, sharing common primitives
- Negotiable delivery guarantees that may be asymmetrical


Authors
-------

| Name        | Affiliation         | Contact                  | Role                                                                            
|-----------------|-------------------------|------------------------------|--------------------------------------------------------------------------------------|
| Anders Furuhed  | Goldman Sachs           | <anders.furuhed@gs.com>           | Protocol Designer                                                               
| David Rosenborg | Goldman Sachs           | <david.rosenborg@gs.com>      | Protocol Designer                                                               
| Rolf Andersson  | Goldman Sachs           | <rolf.andersson@gs.com>          | Contributor
| Jim Northey     | LaSalle Technology      | <jim.northey@fintechstandards.us> |  Global Technical Committee co-chair                                           
| Júlio L R Monteiro  | formerly B3         | <juliolrmonteiro@gmail.com>       | Editor, Working Group convener                                                  
| Aditya Kapur    | CME Group, Inc          | <Aditya.kapur@cmegroup.com>       | Contributor      
| Don Mendelson   | Silver Flash LLC        | <donmendelson@silverflash.net>    | Working Group Lead                                    |
| Li Zhu          | Shanghai Stock Exchange | <lzhu@sse.com.cn>                 | Contributor                                    |


### Related FIX Standards

The FIX Simple Open Framing Header standard governs how messages are delimited and has a specific relationship mentioned in this specification. FIXP interoperates with the other FIX standards at application and presentation layers, but it is not dependent on them. Therefore, they are considered non-normative for FIXP.

| Related Standard | Version | Reference location | Relationship | Normative |
|------------------|---------|--------------------|--------------|-----------|
| Simple Open Framing Header | v1.0 Draft Standard | [SOFH](https://www.fixtrading.org/standards/fix-sofh/)                       | Optional usage at presentation layer | Yes           |
| FIX message specifications   | 5.0 SP2       | [FIX 5.0 SP2](https://www.fixtrading.org/standards/fix-5-0-sp-2/)                       | Presentation and application layers  | No            |
| FIX Simple Binary Encoding   | Version 1.0    | [Simple Binary Encoding](https://www.fixtrading.org/standards/sbe/) | Optional usage at presentation layer | No        |
| Encoding FIX Using ASN.1     | v1.0 Draft Standard |  [ASN.1](https://www.fixtrading.org/standards/asn1/)                      | Optional usage at presentation layer | No            |
| Encoding FIX Using GPB       | v1.0 Draft Standard |  [GPB](https://www.fixtrading.org/standards/gpb/)                      | Optional usage at presentation layer | No            |
|FIX-over-TLS (FIXS) | v1.0 Draft Standard | [FIXS](https://www.fixtrading.org/standards/fixs/) | Security guidelines | Yes |

### Dependencies on Other Specifications

FIXP is dependent on several industry standards. Implementations of FIXP must conform to these standards to interoperate. Therefore, they are normative for FIXP. Other protocols may be used by agreement between counterparties.


| Related Standard  | Version | Reference location | Relationship  | Normative |
|-------------------|---------|--------------------|---------------|-----------|
| RFC 793 Transmission Control Program (TCP)                   | N/A         | <http://tools.ietf.org/html/rfc793> and related standards                 | Uses transport                  | Yes           |
| RFC 6455 WebSocket Protocol                   | N/A         | <http://tools.ietf.org/html/rfc6455>                | Uses transport                  | Yes           |
| RFC 768 User Datagram Protocol (UDP)                         | N/A         | <http://tools.ietf.org/html/rfc768>  | Uses transport                  | Yes           |
| RFC4122 A Universally Unique Identifier (UUID) URN Namespace | N/A         | <http://tools.ietf.org/html/rfc4122> | Uses                            | Yes           |
| UTF-8, a transformation format of ISO 10646                  | N/A         | <http://tools.ietf.org/html/rfc3629> | Uses encoding                   | Yes           |
| Various authentication protocols                             | N/A         |                                      | Optional usage at session layer | No            |

## Specification terms

These key words in this document are to be interpreted as described in
[Internet Engineering Task Force RFC2119](http://www.apps.ietf.org/rfc/rfc2119.html). These terms indicate
an absolute requirement for implementations of the standard: "**must**",
or "**required**".

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

Definitions
-----------

| Term    | Definition  |   
|---------|-------------|                                                                                                                                                                            
| Client      | Initiator of session                                                                                                                                                                        
| Credentials | User identification for authentication                                                                                        
| Flow        | A unidirectional stream of messages. Each flow has one producer and one or more consumers.                                                                                              
| Idempotence | Idempotence means that an operation that is applied multiple times does not change the outcome, the result, after the first time                                                        
| Multicast   | A method of sending datagrams from one producer to multiple consumers
| IETF        | Internet Engineering Task Force                                                                                                                                                
| Server      | Acceptor of session                                                                                                                                                                            
| Session     | A dialog for exchanging application messages between peers.   An established point-to-point session consists of a pair of flows, one in each direction between peers. A multicast session consists of a single flow from the producer to multiple consumers.
| TCP         | Transmission Control Protocol is a set of IETF standards for a reliable stream of data exchanged between peers. Since it is connection oriented, it incorporates some features of a session protocol.  
| TLS         | Transport Layer Security is a set of IETF standards to provide security to a session. TLS is a successor to Secure Sockets Layer (SSL).                                                                                                                                                 
| UDP         | User Datagram Protocol is a connectionless transmission for delivering packets of data. Any rules for a long-lived exchange of messages must be supplied by a session protocol.
| WebSocket   | An IETF protocol that consists of an opening handshake followed by basic message framing, layered over TCP. May be used with TLS.
