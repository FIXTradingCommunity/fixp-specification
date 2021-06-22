# Summary of session messages

## FIXP session messages

| Stage          | Message Name         | Purpose                                | Recoverable   | Idempotent   | Unsequenced / None | Multicast |
|----------------|----------------------|----------------------------------------|:-------------:|:------------:|:------------------:|:---------:|
| Initialization | Negotiate            | Initiates session                      | •             | •            | •                  |           |
|                | NegotiationResponse  | Accepts session                        | •             | •            | •                  |           |
|                | NegotiationReject    | Rejects session                        | •             | •            | •                  |           |
|                | Topic                | Announces a flow                       |               |              |                    | •         |
|                | MessageTemplate      | Delivers template                      | •             | •            | •                  | •         |
| Binding        | Establish            | Binds session to transport             | •             | •            | •                  |           |
|                | EstablishmentAck     | Accepts binding                        | •             | •            | •                  |           |
|                | EstablishmentReject  | Rejects binding                        | •             | •            | •                  |           |
| Transferring   | Sequence             | Initiates a sequenced flow, keep-alive | •             | •            |                    | •         |
|                | Context              | Multiplexing                           | •             | •            | •                  | •         |
|                | UnsequencedHeartbeat | Keep-alive                             |               |              | •                  |           |
|                | RetransmitRequest    | Requests resynchronization             | •             |              |                    |           |
|                | Retransmission       | Resynchronization                      | •             |              |                    |           |
| Unbinding      | Terminate[^1]        | Unbinds a transport                    | •             | •            | •                  |           |
| Finalizing     | FinishedSending      | Ends a logical flow                    | •             | •            | •                  | •         |
|                | FinishedReceiving    | Ends a logical flow                    | •             | •            | •                  | •         |

[^1]: On WebSocket transport, Close frame is used instead of the Terminate message.

## Related application messages

These optional application messages respond to application messages on an idempotent flow.

| Stage        | Message Name | Purpose                                           |
|--------------|--------------|---------------------------------------------------|
| Transferring | Applied      | Acknowledge idempotent operations                 |
|              | NotApplied   | Negative acknowledgement of idempotent operations |

## Summary of protocol violations

If any of these violations by a peer is detected, the session should be immediately terminated. Any application messages that cause a violation, such as a message sent after FinishedSending, should be ignored.

- Sending a session message that is inappropriate to the flow type, such as a Sequence message on an unsequenced flow. See table above.
- Sending an application message on a point-to-point session that is not in established state. That is, prior to an EstablishmentAck message.
- Sending an Establish message without having successfully negotiated a session. That is, a NegotiationResponse message must have been received for the session.
- Sending an application message after logical flow has been finalized with a FinishedSending message. The responder on a point-to-point session may not send an application message after sending a FinishedReceiving message.
- Sending a FinishedReceiving message without having received a FinishedSending message from the peer.
- Sending any application or session message after sending a Terminate message.
- Reusing the session ID of a session that was finalized. (The server may have a practical limit of session history to enforce this rule.)
- Sending a RetransmitRequest message while a retransmission is in progress.
- Sending a RetransmitRequest message with request range out of bounds. That is, it is a violation to request a retransmission of a message with a sequence number that has not been sent yet.
