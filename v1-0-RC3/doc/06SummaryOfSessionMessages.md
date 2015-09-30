Summary of Session Messages
===========================

FIXP Session Messages
---------------------

| Stage          | Message Name         | Purpose                                | Recoverable   | Idempotent   | Unsequenced / None | Multicast |
|----------------|----------------------|----------------------------------------|:-------------:|:------------:|:------------------:|:---------:|
| Initialization | Negotiate            | Initiates session                      | •             | •            | •                  |           |
|                | NegotiationResponse  | Accepts session                        | •             | •            | •                  |           |
|                | NegotiationReject    | Rejects session                        | •             | •            | •                  |           |
|                | Topic                | Announces a flow                       |               |              |                    | •         |
| Binding        | Establish            | Binds session to transport             | •             | •            | •                  |           |
|                | EstablishmentAck     | Accepts binding                        | •             | •            | •                  |           |
|                | EstablishmentReject  | Rejects binding                        | •             | •            | •                  |           |
| Transferring   | Sequence             | Initiates a sequenced flow, keep-alive | •             | •            |                    | •         |
|                | Context              | Multiplexing                           | •             | •            | •                  | •         |
|                | UnsequencedHeartbeat | Keep-alive                             |               |              | •                  |           |
|                | RetransmitRequest    | Requests resynchronization             | •             |              |                    |           |
|                | Retransmission       | Resynchronization                      | •             |              |                    |           |
| Unbinding      | Terminate            | Unbinds a transport                    | •             | •            | •                  |           |
| Finalizing     | FinishedSending      | Ends a logical flow                    | •             | •            | •                  | •         |
|                | FinishedReceiving    | Ends a logical flow                    | •             | •            | •                  | •         |

Related Application Messages
----------------------------

These optional application messages respond to application messages on an idempotent flow.

| Stage        | Message Name | Purpose                                           |
|--------------|--------------|---------------------------------------------------|
| Transferring | Applied      | Acknowledge idempotent operations                 |
|              | NotApplied   | Negative acknowledgement of idempotent operations |

Summary of Protocol Violations
------------------------------

If any of these violations by a peer is detected, the session should be terminated.

-   Sending a session message that is inappropriate to the flow type, such as a Sequence message on an unsequenced flow. See table above.

-   *Sending an application message on a session that is not in established state.*

-   *Reusing the session ID of a session that was finalized.*

-   Sending a RetransmitRequest while a retransmission is in progress.

-   *Sending a RetransmitRequest with request range out of bounds. That is, it is a violation to request a retransmission of a message with a sequence number that has not been sent yet.*
