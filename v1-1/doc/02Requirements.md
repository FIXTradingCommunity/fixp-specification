Requirements
============

Business Requirements
---------------------

Create an enhanced session protocol that can provide reliable, highly efficient, exchange of messages to support high performance financial messaging, over a variety of transports.

Protocol shall be fit for purpose for current high message rates, low latency environments in financial markets, but should be to every extent possible applicable to other business domains. There is no reason to limit or couple the session layer to the financial markets / trading business domain without extraordinary reason.

Support common message flow types: Recoverable, Unsequenced, Idempotent (operations guaranteed to be applied only once), and None (for a one-way flow of messages).

Protocol shall support asymmetric models, such as market participant to market, in addition to peer-to-peer (symmetric). Allow the communication of messages to multiple receivers (broadcast).

The session protocol does not require or recommend a specific authentication protocol. Counterparties are free to agree on user authentication techniques that fit their needs.

Technical Requirements
----------------------

### Protocol Layering

This standard endeavors to maintain a clear separation of protocol layers, as expressed by the Open Systems Interconnection model (OSI). The responsibilities of a session layer are establishment, termination and restart procedures and rules for the exchange of application messages.

The protocol shall be independent of message encoding (presentation layer), to provide the maximum utility. Encoding independence applies both to session layer messages specified in this document as well as to application messages. It is simpler if session protocol messages are encoded the same way as application messages, but that is not a requirement of this session protocol.

Users are free to specify message encodings by agreement with counterparties. FIX provides Simple Binary Encoding as well as mappings of FIX to other high performance encodings such as ASN.1, and Google Protocol Buffers. See the list of related standards above. Other recognized encodings may follow in the future.

Of necessity, the session protocol makes some adaptations for transport layer protocols used by the session layer since the capabilities of common transports are quite different. In particular, TCP is connection- and stream-oriented and implements its own reliable delivery mechanisms. Meanwhile, UDP is datagram-oriented and does not guarantee delivery in order. Unfortunately, these characteristics bleed across protocol layers.

### Security Mechanisms

FIXP does not specify its own security features. Rather, the FIX Trading Community separately issues security requirements and recommendations that may apply to FIXP
and other FIX session protocols. Due to the ever-changing nature of information security, the requirements and recommendations are likely to be updated periodically. In general, it is recommended that FIX traffic be protected by using proven controls specified by the FIX Trading Community. See the FIX-over-TLS (FIXS) standard (reference listed in section 1).

The FIX Trading Community is in the process of specifying how to authenticate parties using TLS and optionally using FIX credentials.  FIX credentials can be used to authenticate a client after an underlying TLS session has been established. FIXP supports this use case by providing a field for credentials in the FIXP session negotiation handshake.

### Low Overhead

Minimum overhead is added to the messages exchanged between peers, using only the strictly necessary control messages.

By agreement between counterparties, a message framing protocol may be used to delimit messages. This relieves the session layer of application message decoding to determine message boundaries. FIX offers the Simple Open Framing Header standard for framing messages encoded with binary wire formats. See standards references above.
