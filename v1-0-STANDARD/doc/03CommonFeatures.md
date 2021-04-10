Common Features
===============
Usage and Naming Conventions
----------------------------

All symbolic names for messages and fields in this protocol must follow the same naming convention as other FIX specifications: alphanumeric characters plus underscores without spaces.

Data Types
----------

Data types used in this standard are abstract. 
The terminology used to define them are to be interpreted as described in international standard
[ISO/IEC 11404 Information technology -- General-Purpose Datatypes ](http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=39479). 

> It defines a set
of datatypes, independent of any particular programming language specification or implementation, that is rich
enough so that any common datatype in a standard programming language or service package can be
mapped to some datatype in the set. 


Actual wire format of FIXP is left to the presentation layer implementation.

| **FIXP Type** | **Description**               | **General Purpose Type** | **Properties**                                                                                                                                |
|------------------|-------------------------|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| u8               |  Unsigned number        |   Integer              |  Ordered, exact, numeric, bounded. Range 0..2<sup>8</sup>-1                                                                                                                                      |
| u16              |  Unsigned number        |  Integer               |  Ordered, exact, numeric, bounded. Range 0..2<sup>16</sup>-1                                                                                                                                                                     |
| u32              |  Unsigned number        |  Integer               |  Ordered, exact, numeric, bounded. Range 0..2<sup>32</sup>-1                                                                                                                                                                 |
| u64              |  Unsigned number        |  Integer               |  Ordered, exact, numeric, bounded. Range 0..2<sup>64</sup>-1                      
| UUID             | RFC 4122 version 4 compliant unique identifier | Octet string   | Fixed size 16.
| String           | Text                    | Character string                | Unordered, exact, non-numeric, denumerable. Parameterized by character set.                                                   |
| nanotime         | Time in nanoseconds     | Date-and-Time          |  Ordered, exact, numeric, bounded. Time-unit = nanosecond. Same range as u64.                                                                                                     |
| DeltaMillisecs   | Number of milliseconds  | Time interval          |   Ordered, exact, numeric, bounded. Time-unit = millisecond. Same range as u32.                                                                                                                                             |
| Object           | Unspecified data content                        | Octet string                | Unordered, exact, non-numeric, denumerable.                                                                                                        |
| Enumeration      | A finite set of values. Error and message type identifiers are enumerated by symbolic name in this specification.  |  State   | Unordered, exact, non-numeric. The value space of a state datatype is the set comprising exactly the named values in the state-value-list, each of which is designated by a unique state-literal. |

FIXP Session Messages
---------------------

The FIXP protocol defines several messages that are used to establish and tear down sessions and control sequencing of messages for delivery. Message layouts are specified in this document by symbolic names and the abstract data types listed above. Wire format details are provided by supplements to this specification for each of the supported FIX encodings.

Those supplements also explain how to distinguish session messages from application messages in that specific encoding. FIXP does not require that application messages be in the same encoding as session messages. With the use of Simple Open Framing Header to identify the encoding of the following message, it is even possible to mix wire formats in a session. However, a common encoding for all messages likely permits simpler implementation.

### Message Type Identification

Message types are listed in this document as an enumeration of symbolic names. Each FIX encoding tells how message type identifiers are encoded on the wire.

See section 4 below for an enumeration of message types.

### Fields

Exact wire format is determined by a presentation layer protocol (message encoding). However, fields should be encoded in the same order that they are listed in this specification.

### Message Framing

FIXP does not require application messages to have a session layer header. Application messages may have their own presentation layer header, depending on encoding. However, application messages may immediately follow Sequence without any intervening session layer prologue.

Optionally, application messages may be delimited by use of the Simple Open Framing Header. This is most useful if session message encoding is different than application message encoding or if a session carries application messages in multiple encodings. The framing header identifies the encoding of the message that follows and gives its overall length. If it is used, then FIXP need not parse application messages to determine length and keep track of message counts in a flow.

Session Properties
------------------

### Session Identification

Each session must be identified by a unique Session ID encoded as a UUID version 4 (RFC 4122) assigned by the client. The benefit of using an UUID is that it is effortless to allocate in a distributed system. It is also simple and efficient to hash and therefore easy to look up at the endpoints. The downside is a larger size overhead. The identifier however does not appear in the stream except once at the start of each datagram, when using UDP, or when sessions are multiplexed, regardless of the underlying transport that is used. For a non-multiplexed TCP session, the identifier therefore appears only once during the lifetime of the TCP session. A session identifier must be unique, not only amongst currently active sessions, but for all time. Reusing a session ID is a protocol violation.

### User Identification

The FIX Trading Community is in the process of specifying how to authenticate counterparties. This is expected to primarily using TLS and, optionally, using TLS in conjunction with FIX credentials.  FIX credentials can be used after a TLS transport has been established, whilst its FIXP session is being established. In any event, the security features will be specified outside of FIXP, but may make use of FIXP credentials.

FIXP does not dictate the format of user credentials. They are agreed between counterparties and should be documented in rules of engagement. The Credentials field in FIXP is of datatype Object (opaque data) so no restriction on its contents is imposed by the protocol.

### Session Lifetime

A logical session is established between counterparties and lasts until information flows between them are complete. Commonly, such flows are concurrent with daily trading sessions, but no set time limit is imposed by this protocol. Rather, timings for session start and end are set by agreement between counterparties.

A logical session is identified by a session ID, as described above, until its information flows are finalized. After finalization, the old session ID is no longer valid, and messages are no longer recoverable. Counterparties may subsequently start a new session under a different ID.

A logical session is bound to a transport, but a session may outlive a transport connection. The binding to a transport may be terminated intentionally or may be triggered by an error condition. However, a client may reconnect and bind the existing session to the new transport. When re-establishing an existing session, the original session ID continues to be used, and recoverable messages that were lost by disconnection may be recovered.

### Flow Types

Each stream of application messages in one direction on a FIXP session is called a flow. FIXP supports configurable delivery guarantees for each flow. A bidirectional session may have asymmetrical flows.

From highest to lowest delivery guarantee, the flow types are:

-   **Recoverable**: Guarantees exactly-once message delivery. If gaps are detected, then missed messages may be recovered by retransmission.

-   **Idempotent**: Guarantees at-most-once delivery. If gaps are detected, the sender is notified, but recovery is under control of the application, if it is done at all.

-   **Unsequenced**: Makes no delivery guarantees (best-effort). This choice is appropriate if guarantees are unnecessary or if recovery is provided at the application layer or through a different communication channel.

-   **None**: No application messages should be sent in one direction of a session. If ClientFlow is None, then application messages flow only from server to client.

#### Flow Restrictions

All the flow types listed above are possible for a point-to-point session. Only one of the flows may be None, meaning that although the transport supports bidirectional transmissions, application messages flow in only one direction. 
By agreement between counterparties, only certain of these flow types may be supported for a particular service.

A multicast session only supports one flow from producer to consumers, and it is restricted to the Idempotent type, possibly with out-of-band recovery.

Message Sequencing
------------------

### Sequence Numbering

Sequence numbering supports ordered delivery and recovery of messages. In FIXP, only application messages are sequenced, not session protocol messages. A Sequence message (or Context message described below) must be used to start a sequenced flow of application messages. Any applications message passed after a Sequence message is implicitly numbered, where the first message after Sequence has the sequence number NextSeqNo.

Sending a Sequence or Context message on an Unsequenced or None flow is a protocol violation.

**Sequence**

Sequence message must be used only in a Recoverable or Idempotent flow on a non-multiplexed transport.

| **Field name** | Type | Required | Value    | Description |
|----------------|------|----------|----------|-------------|
| MessageType    | Enum | Y        | Sequence |
| NextSeqNo      | u64  | Y        |          | The sequence number of the next message after the Sequence message.



### Datagram oriented protocol considerations

Using a datagram-oriented transport like UDP, each datagram carrying a sequenced flow, the Sequence message is key to detecting packet loss and packet reordering and must precede any application messages in the packet.

FIXP provides no mechanism for fragmenting messages across datagrams. In other words, each application message must fit within a single datagram on UDP.

### Multiplexed session considerations

If sessions are multiplexed over a transport, they should be framed independently. If a framing header is used, the same framing protocol must be used for all sessions on a multiplexed transport. There would be no practical way to delimit messages with mixed framing policies.

If flows are multiplexed over a transport, the transport does not imply the session. When multiplexing, the Context message expands Sequence to also specify the session being sequenced. Context is used to set the session for the remainder of the current datagram (in a datagram-oriented transport) or until a new Context is passed. In a sequenced flow, Context supersedes the role of Sequence by including NextSeqNo (optimizes away the Sequence that would otherwise follow).

**Context**

Context message must be used in a Recoverable or Idempotent flow on a multiplexed transport.

| **Field name** | Type | Required | Value    | Description |
|----------------|------|----------|----------|-------------|
| MessageType    | Enum | Y        | Context  |
| SessionId      | UUID | Y        |          | Session Identifier
| NextSeqNo      | u64  | N        |          | The sequence number of the next message after the Context message.

### Context switches

A change in session context ends the sequence of messages implicitly and the sender must pass a Sequence or Context message again before starting to send sequenced messages. A Sequence message must be sent if the session is not multiplexed and Context must be sent if it is multiplexed.

Changes of session context include:

-   Interleaving of new, real-time messages and retransmitted messages.

-   Switching from one multiplexed session to another when sharing a transport.


### Application Layer Sequencing

Application-layer sequencing may be used on an Unsequenced flow as an alternative to FIXP session-layer message sequencing. If used, each application message body must contain an identifier used to sequence messages, and the application provider must specify rules for out-of-order delivery and recovery.

In-band Template Delivery
-------------------------

FIXP is independent of the wire format of session and application messages. However, some message encodings are controlled by templates that must be shared between peers in order to interoperate. Therefore, FIXP provides a means to deliver templates or message schemas. 

All FIX encodings that use a template or message schema are supported. They are identified by the same code registered for Simple Open Framing Header (SOFH).

Templates may be delivered either over a point-to-point or multicast session. MessageTemplate may be sent at any time. For a multicast, it is recommended to resend templates at intervals to support late joiners. It is assumed to apply to all sessions on a transport in the case of multiplexing.


**MessageTemplate**

| **Field name** | Type     | Required | Value           | Description |
|----------------|----------|----------|-----------------|-------------|
| MessageType    | Enum     | Y        | MessageTemplate |
| EncodingType   | u32      | Y        |                 | Identifier registered for SOFH
| EffectiveTime  | nanotime | N        |                 | Date-time that the template becomes effective. If not present, effective immediately.
| Version        | Object   | N        |                 | Version and format description. Version may also be embedded in the template itself, depending on protocol.
| Template       | Object   | Y        |                 | Content of the template or message schema

