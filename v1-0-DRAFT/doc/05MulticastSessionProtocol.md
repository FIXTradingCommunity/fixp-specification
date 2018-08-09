Multicast Session Protocol
==========================

A multicast session conveys messages one way from a publisher to any number of listeners. It is conducted over a connectionless transport such UDP multicast. Multicast session protocol is typically used for publishing market data or common reference information to many consumers. Multiple independent flows may be multiplexed over a shared multicast transport.

Multicast Session Lifecycle
---------------------------

Since a multicast transport is connectionless, there is no negotiation or binding or unbinding of the transport as in the point-to-point protocol. Thus, Negotiation and Establishment messages and their respective responses are not used.

Multicast addresses and publishing schedules must be provided out-of-band to listeners. To capture all messages, listeners must be ready to receive at scheduled times. Publishing continues until the end of a logical flow.

### Multicast Session Establishment

Like a point-to-point session, a multicast session is identified by a UUID. Each time a session is initiated, a new UUID must be generated, and sequence numbers of subsequent application messages must begin with 1.

#### Topic Message

To associate a transient UUID to a permanent or semi-permanent classification of messages, a Topic message must be used to initiate a flow. Multiple topics may be published on a transport.

FlowType = Recoverable | Idempotent 

Valid flow types on a multicast session are:

-   **Recoverable**: Messages are sequenced and recoverable. Since the transport is one-way, RetransmitRequests must be delivered through a separate session, however.

-   **Idempotent**: Messages are sequenced to allow detection of loss but any missed messages are not recoverable.

Each Topic carries a Classification for the flow to associate it to a permanent or semi-permanent application layer entity. Typical classifications are product types, market symbols or the like.

To support late joiners, Topic messages should be repeated at regular intervals on a session. This specification does not dictate a specific interval, but the shorter the interval, the less time it takes for a late joiner to identify flows. It is recommended that Topic message be sent with Session heartbeats when the session is otherwise idle. See session heartbeat section below.

**Topic** 

| **Field name** | **Type** | **Required** | **Value** | **Description** |
|----------------|----------|--------------|-----------|-----------------|
| MessageType    | Enum     | Y            | Topic     |                 |
| SessionId      | UUID     | Y            |           | Session Identifier
| Flow           | FlowType Enum | Y       |           | Type of flow from publisher
| Classification | Object   | Y            |           | Category of application messages that follow 

### Finalizing a Multicast Session

Finalization ends a logical flow when there are no more application messages to send. A multicast flow should be finalized by transmitting a FinishedSending message. No further messages should be sent, and the session ID is no longer valid after that.

Idempotent Flow over Multicast
------------------------------
The goal of an idempotent flow over multicast is to provide at-most-once delivery guarantee to each consumer. Unlike a point-to-point session, however, there is no opportunity to return a NotApplied message to the producer over a one-way transport if a sequence number gap is detected. Therefore, on a multicast, an idempotent flow provides a means to detect data loss, but no direct way to notify the producer or initiate recovery.

An idempotent flow is implemented by the producer in the same way over a multicast transport as for point-to-point over UDP unicast. Each datagram must begin with either a Sequence message if non-multiplexed or a Context message if the flow is sent over a multiplexed transport.

Session Heartbeat
-----------------

During the lifetime of a multicast session, its publisher should send Sequence or Context messages as a heartbeat at regular intervals when the session is otherwise inactive. This allows a receiver to tell whether a session is live and has not reached the end of its logical flow. If only a single Topic is published, then Sequence message may be used for heartbeats since there is no context switch. If multiple topics are published on a shared multicast transport, then Context must be used. See the Common Features section above for a description of sequence numbering and the Sequence and Context messages.

In addition to the Sequence or Context message, it is recommended that a Topic message should be published on the heartbeat interval. This provides an opportunity for late joiners to gather session characteristics during every idle period.