Common Features
===============
Usage and Naming Conventions
----------------------------

All symbolic names for messages and fields in this protocol should follow the same naming convention as other FIX specifications: alphanumeric characters plus underscores without spaces.

Data Types
----------

Data types are abstract. Actual encoding of FIXP is left to the implementation.

| **Logical Type** | **Range**               | **Native Type** | **Comments**                                                                                                                                |
|------------------|-------------------------|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| u8               | 0..2<sup>8</sup>-1                |                 |                                                                                                                                             |
| u16              | 0..2<sup>16</sup>-1               |                 |                                                                                                                                             |
| u32              | 0..2<sup>32</sup>-1               |                 |                                                                                                                                             |
| u64              | 0..2<sup>64</sup>-1               |                 |                                                                                                                                             |
| UUID             | RFC 4122 compliant UUID |                 | The requirement is to provide a mechanism that can be self-generated and guaranteed free of collision. Implementers are encouraged to adopt version 4.                                                                                              |
| String           | text                    |                 | UTF-8, length may need to be specified as part of the encoding.                                                                             |
| nanotime         | Time in nanoseconds     | u64             | Number of nanoseconds since UNIX epoch                                                                                                      |
| DeltaMillisecs   | Number of milliseconds  | u32             |                                                                                                                                             |
| Object           |                         |                 | Unspecified data content Requires some way to determine length                                                                                                        |
| Enumeration      | A finite set of values  |                 | Error and message type identifiers are enumerated by symbolic name in this specification. Wire format is determined by a specific encoding. |

FIXP Session Messages
---------------------

The FIXP protocol defines several messages that are used to establish and tear down sessions and control sequencing of messages for delivery. Message layouts are specified in this document by symbolic names and the abstract data types listed above. Wire format details are provided by supplements to this specification for each of the supported FIX encodings.

Those supplements also explain how to distinguish session messages from application messages in that specific encoding. FIXP does not require that application messages be in the same encoding as session messages. With the use of Simple Open Framing Header to identify the encoding of the following message, it is even possible to mix wire formats in a session. However, a common encoding for all messages likely permits simpler implementation.

### Message Type Identification

Message types are listed in this document as an enumeration of symbolic names. Each FIX encoding tells how message type identifiers are encoded on the wire.

See section 4 below for an enumeration of message types.

Message Sequencing
------------------

### Sequence Numbering

Sequence numbering supports ordered delivery and recovery of messages. In FIXP, only application messages are sequenced, not session protocol messages. A Sequence message is used to start a sequenced flow of application messages. Any applications message passed after a Sequence message is implicitly numbered, where the first message after Sequence has the sequence number NextSeqNo.

Sending a Sequence message on an Unsequenced or None (one-way session) flow is a protocol violation.

**Sequence**

| **Field name** | Type | Required | Value    | Description |
|----------------|------|----------|----------|-------------|
| MessageType    | Enum | Y        | Sequence |
| NextSeqNo      | u64  | Y        |          | The sequence number of the next message after the Sequence message.

### Message framing

FIXP does not require application messages to have a session layer header. Application messages may have their own presentation layer header, depending on encoding. However, application messages may immediately follow Sequence without any intervening session layer prologue.

Optionally, application messages may be delimited by use of the Simple Open Framing Header. This is most useful if session message encoding is different than application message encoding or if a session carries application messages in multiple encodings. The framing header identifies the encoding of the message that follows and gives its overall length. If it is used, then FIXP need not parse application messages to determine length and keep track of message counts in a flow.

### Application message sequencing considerations

An application layer defined on top is obviously free to put any required application level sequencing inside messages.

### Datagram oriented protocol considerations

Using a datagram oriented transport like UDP, each datagram carrying a sequenced flow, the Sequence message is key to detecting packet loss and packet reordering and must precede any application messages in the packet.

FIXP provides no mechanism for fragmenting messages across datagrams. In other words, each application message must fit within a single datagram on UDP.

### Multiplexed session considerations

If sessions are multiplexed over a transport, they are framed independently. When multiplexing, the Context message expands Sequence to also specify the session being sequenced.

If flows are multiplexed over a transport, the transport does not imply the session. Context is used to set the session for the remainder of the current datagram (in a datagram oriented transport) or until a new Context is passed. In a sequenced flow, Context can take the role of Sequence by including NextSeqNo (optimizes away the Sequence that would otherwise follow).

**Context**

| **Field name** | Type | Required | Value    | Description |
|----------------|------|----------|----------|-------------|
| MessageType    | Enum | Y        | Context  |
| SessionId      | UUID | Y        |          | Session Identifier
| NextSeqNo      | u64  | N        |          | The sequence number of the next message after the Context message.

### Sequence context switches

A change in session context ends the sequence of messages implicitly and the sender must pass a Sequence or Context message again before starting to send sequenced messages. A Sequence message must be sent if the session is not multiplexed and Context must be sent if it is multiplexed.

Changes of session context include:

-   Interleaving of new, real-time messages and retransmitted messages.

-   Switching from one multiplexed session to another when sharing a transport.

Session Properties
------------------

### Session Identification

Each session is identified by a unique Session ID encoded as a UUID version 4 (RFC 4122) assigned by the client. The benefit of using an UUID is that it is effortless to allocate in a distributed system. It is also simple and efficient to hash and therefore easy to look up at the endpoints. The downside is a larger size overhead. The identifier however does not appear in the stream except once at the start of each datagram, when using UDP, or when sessions are multiplexed, regardless of the underlying transport that is used. For a non-multiplexed TCP session, the identifier therefore appears only once during the lifetime of the TCP session. A UUID is intended to be unique, not only amongst currently active sessions, but for all time. Reusing a session ID is a protocol violation.

### User Identification

Clients that initiate sessions are identified by credentials that are assigned by or known to their counterparties. Credentials identify business entities, such as trading firms.

Credentials should not be used as keys or passwords for authentication, at least not without other supporting security mechanisms. Note that permanent or even rotating passwords are vulnerable to replay attack and thus have little security value.

### Session Lifetime

A logical session is established between counterparties and lasts until information flows between them are complete. Commonly, such flows are concurrent with daily trading sessions, but no set time limit is imposed by this protocol. Rather, timings for session start and end are set by agreement between counterparties.

A logical session is identified by a session ID, as described above, until its information flows are finalized. After finalization, the old session ID is no longer valid, and messages are no longer recoverable. Counterparties may subsequently start a new session under a different ID.

A logical session is bound to a transport, but a session may outlive a transport connection. The binding to a transport may be terminated intentionally or may be triggered by an error condition. However, a client may reconnect and bind the existing session to the new transport. When re-establishing an existing session, the original session ID continues to be used, and recoverable messages that were lost by disconnection may be recovered.