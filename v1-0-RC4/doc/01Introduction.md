Introduction
============

FIX Performance Session Layer (FIXP) is a “lightweight point-to-point protocol” introduced to provide an open industry standard for high performance computing requirements currently encountered by the FIX Community. FIXP is a derived work. The origin and basis for FIXP are the FIX session layer protocols and the designed and implemented by NASDAQOMX, SoupTCP, SoupBinTCP, and UFO (UDP for Orders). Every attempt was made to keep FIXP as close to the functionality and behavior of SoupBinTCP and UFO as possible. Extensions and refactoring were performed as incremental improvements. Every attempt was made to limit the FIXP to establishing and maintaining a communication session between two end points in a reliable manner, regardless of the reliability of the underlying transport.

FIXP features

-   Binary protocol

-   Very simple lightweight point-to-point session layer for reliable communication.

-   Communication protocol independent

-   Encoding independent

-   Restricted to initiating, maintaining, and reestablishing a session.

The idea to provide an open standard high performance session layer with SoupBinTCP as its source came from two simultaneous sources.

1.  The BVMF (Brazil) began investigating SoupBinTCP as a lightweight and simple alternative for market data delivery due to issues with Multicast IP infrastructure at member firms. The idea to align packet types to existing FIX message types was created during a meeting prior to the start of the High Performance Working Group.

2.  Pantor Engineering prototyped a solution for high performance computing that used FAST datatypes (without field operators) carried over a SoupBinTCP session. Anders Furuhed presented the concept at the FIX Nordic event.

Authors
-------

| Name        | Affiliation         | Contact                  | Role                                                                            
|-----------------|-------------------------|------------------------------|--------------------------------------------------------------------------------------|
| Anders Furuhed  | Pantor Engineering      | <anders@pantor.com>          | Protocol Designer                                                                    |
| David Rosenborg | Pantor Engineering      | david.rosenborg@pantor.com   | Protocol Designer                                                                    |
| Rolf Andersson  | Pantor Engineering      | <rolf@pantor.com>            | Contributor, GTC Governance Board member                                             |
| Jim Northey     | LaSalle Technology      | <jimn@lasalletech.com>       | Editor, Working group convener                                                       |
| Julio Monteiro  | BVMF Bovespa            | <jmonteiro@bvmf.com.br>      | Editor, Working Group convener                                                       |
| Aditya Kapur    | CME Group, Inc          | <Aditya.kapur@cmegroup.com>  | Working Group Participant – provided document editing and input on exchange adoption |
| Don Mendelson   | CME Group, Inc.         | <Don.Mendelson@cmegroup.com> | Working Group Participant and regular contributor                                    |
| Li Zhu          | Shanghai Stock Exchange | <lzhu@sse.com.cn>            | Working Group Participant and regular contributor                                    |

Relevant and Related Standards
------------------------------

### Sources

These standards were sources for concepts but are non-normative for FIXP.

| Reference                    | Version               | Relevance                                                 | Normative |
|----------------------------------|---------------------------|----------------------------------------------------------------|---------------|
| UFO (UDP for Orders) NASDAQ OMX  | Version 1.0, July 3, 2008 | Basis for high performance session layer.                      | No            |
| SoupBinTCP NASDAQ OMX                        | 3.00                      | Basis for high performance session layer.                      | No            |
| FIXT Session Layer Specification | 1.1                       | The previous FIX session layer specification                   | No            |
| XMIT                             | alpha15                   | High performance session protocol design by Pantor Engineering | No            |

### Related FIX Standards 

The FIX Simple Open Framing Header standard governs how messages are delimited and has a specific relationship mentioned in this specification. FIXP interoperates with the other FIX standards at application and presentation layers, but it is not dependent on them. Therefore, they are considered non-normative for FIXP.

| Related Standard         | Version    | Reference location | Relationship                    | Normative |
|------------------------------|----------------|------------------------|--------------------------------------|---------------|
| Simple Open Framing Header | Draft Standard   |                        | Optional usage at presentation layer | Yes           |
| FIX message specifications   | 5.0 SP 2       |                        | Presentation and application layers  | No            |
| FIX Simple Binary Encoding   | Draft Standard |                        | Optional usage at presentation layer | No            |
| Encoding FIX Using ASN.1     | Draft Standard |                        | Optional usage at presentation layer | No            |
| Encoding FIX Using GPB       | RC2            |                        | Optional usage at presentation layer | No            |

### Dependencies on Other Specifications

FIXP is dependent on several industry standards. Implementations of FIXP must conform to these standards to interoperate. Therefore, they are normative for FIXP. Other protocols may be used by agreement between counterparties.


| Related Standard  | Version | Reference location | Relationship  | Normative |
|--------------------------------------------------------------|-------------|--------------------------------------|---------------------------------|---------------|
| RFC 793 Transmission Control Program (TCP)                   | N/A         | <http://tools.ietf.org/html/rfc793> and related standards                 | Uses transport                  | Yes           |
| RFC 768 User Datagram Protocol (UDP)                         | N/A         | <http://tools.ietf.org/html/rfc768>  | Uses transport                  | Yes           |
| RFC4122 A Universally Unique Identifier (UUID) URN Namespace | N/A         | <http://tools.ietf.org/html/rfc4122> | Uses                            | Yes           |
| UTF-8, a transformation format of ISO 10646                  | N/A         | <http://tools.ietf.org/html/rfc3629> | Uses encoding                   | Yes           |
| Various authentication protocols                             | N/A         |                                      | Optional usage at session layer | No            |

Intellectual Property Disclosure
--------------------------------

Authors should provide a list of any intellectual property

-   Related Intellectual Property– name and or description of related intellectual property.

-   Type of IP: Copyright, Patent, Trademark, Trade Secret

-   IP Owner– Entity that owns the IP

-   Relationship – relationship of the related standard to the technical standard being proposed. Can be: **Extends** the related standard, **Overlaps** with related standard, **Incorporates** related standard, **Inspiration** from related standard , **Uses** related standard, **Replaces** related standard.

| Related Intellectual Property | Type of IP (copyright, patent) | IP Owner | Relationship to proposed standard |         
|---------------------------------------------------------|------------------------------------|--------------------|--------------------------------------------------------------------------|
| Blink http://blinkprotocol.org/spec/BlinkSpec-beta3.pdf | Copyright                          | Pantor Engineering |                                                                          |
| XMIT                                                    | Copyright                          | Pantor Engineering | Basis for design of protocol                                             |
| Soup, SoupBinTCP, UFO (UDP for Orders), and MoldUDP     | Copyright                          | NASDAQOMX          | FIXP is intended to provide functionality equivalent to these protocols. |

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
| Client      | Initiator of session.                                                                                                                                                                         
| Credentials | In FIXP, credentials are used only for business entity identification, not as a security key.                                                                                           
| Flow        | A unidirectional stream of messages. Each flow has one producer and one or more consumers.                                                                                              
| Idempotence | Idempotence means that an operation that is applied multiple times does not change the outcome, the result, after the first time                                                        
| IP MC       | IP Multicast                                                                                                                                                               
| Server      | Acceptor of session                                                                                                                                                                            
| Session     | A dialog for exchanging application messages between peers.   An established point-to-point session consists of a pair of flows, one in each direction between peers. A multicast session consists of a single flow from the producer to multiple consumers. 
| TCP         | Transmission Control Protocol                                                                                                                                                                  
| UDP         | User Datagram Protocol           