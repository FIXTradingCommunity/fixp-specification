Appendix A - Usage Examples (TCP)
=================================

These use cases contain sample values for illustrative purposes only

Initialization
--------------

### <span id="_Toc222136886" class="anchor"><span id="_Toc272405426" class="anchor"><span id="_Toc272405494" class="anchor"><span id="_Toc353265861" class="anchor"></span></span></span></span>Session negotiation (both Recoverable)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | Recoverable     | --              | **123**         |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | Recoverable     | **--**          |

### Session negotiation (both Unsequenced)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | Unsequenced     | --              | 123             |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | Unsequenced     | --              |

### Session negotiation (Client Idempotent and Server Recoverable – highly recommended)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | Idempotent      | --              | 123             |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | Recoverable     | --              |

### Session negotiation (Client None and Server Recoverable)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | None            | --              | 123             |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | Unsequenced     | --              |

### Session negotiation (Client Unsequenced and Server Recoverable)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | Unsequenced     | --              | 123             |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | Recoverable     | --              |

### Session negotiation (Client None and Server Unsequenced)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | None            | --              | 123             |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | Unsequenced     | --              |

### Session negotiation (rejects)

#### Bad credentials

For example – Valid Credentials are 123 but Negotiate message is sent with Credentials as 456 then it will be rejected.

| **Message Received** | **Message Sent**  | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Code**        | **Reason**        | **Credentials** |
|----------------------|-------------------|----------------|---------------|-----------------------|-----------------|-----------------|-------------------|-----------------|
| Negotiate            |                   | ABC            | T1            | --                    | Idempotent      |                 | --                | 456             |
|                      | NegotiationReject | ABC            | --            | T1                    | --              | Bad Credentials | Invalid Trader ID | --              |

#### Flow type not supported

For example – Recoverable flow from Client is not supported but Negotiate message is sent with Client Flow as Recoverable then it will be rejected.

| **Message Received** | **Message Sent**  | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Code**             | **Reason**                         | **Credentials** |
|----------------------|-------------------|----------------|---------------|-----------------------|-----------------|----------------------|------------------------------------|-----------------|
| Negotiate            |                   | ABC            | T1            | --                    | Recoverable     | --                   | --                                 | 123             |
|                      | NegotiationReject | ABC            | --            | T1                    | --              | FlowTypeNotSupported | Client Recoverable Flow Prohibited | --              |

#### Invalid session ID

For example – Session ID does not follow UUID or GUID semantics as per RFC 4122 and Negotiate message is sent with Session ID as all zeros then it will be rejected.

| **Message Received** | **Message Sent**  | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Code**    | **Reason**               | **Credentials** |
|----------------------|-------------------|----------------|---------------|-----------------------|-----------------|-------------|--------------------------|-----------------|
| Negotiate            |                   | 000            | 0             | --                    | Idempotent      | --          | --                       | 123             |
|                      | NegotiationReject | 000            | --            | 0                     | --              | Unspecified | Invalid SessionID Format | --              |

#### Invalid request timestamp

For example – Timestamp follows Unix Epoch semantics and is to be sent with nanosecond level precision but Negotiate message is sent with Timestamp as Unix Epoch but expressed as number of seconds then it will be rejected.

| **Message Received** | **Message Sent**  | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Code**    | **Reason**               | **Credentials** |
|----------------------|-------------------|----------------|---------------|-----------------------|-----------------|-------------|--------------------------|-----------------|
| Negotiate            |                   | ABC            | 86400         | --                    | Idempotent      | --          | --                       | 123             |
|                      | NegotiationReject | ABC            | --            | 86400                 | --              | Unspecified | Invalid Timestamp Format | --              |

#### Mismatch of sessionID/RequestTimestamp

For example – the session identifier and the request timestamp in the NegotiationResponse do not match with the Negotiate message then the acknowledgment MUST be ignored and an internal alert may be generated followed by a new Negotiate message

| **Message Received**                                                                                                                                 | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** |
|------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|
| Negotiate                                                                                                                                            |                     | ABC            | T1            | --                    | Recoverable     | --              | 123             |
|                                                                                                                                                      | NegotiationResponse | DEF            | --            | T2                    | --              | Recoverable     | --              |
| \<Ignore NegotiationResponse message since it contains incorrect Session ID and/or RequestTimestamp and Generate Internal Alert and Possibly Retry\> |
| Negotiate                                                                                                                                            |                     | XYZ            | T3            | --                    | Recoverable     | --              | 123             |
| \<New Negotiate message should contain new Session ID\>                                                                                              |

#### NegotiationResponse or Reject Not Received

For example – the Negotiate message is neither accepted nor rejected and one KeepAliveInterval\* has lapsed then an internal alert may be generated followed by a new Negotiate message.

| **Message Received**                                      | **Message Sent** | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** |
|-----------------------------------------------------------|------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|
| Negotiate                                                 |                  | ABC            | T1            | --                    | Recoverable     | --              | 123             |
| \<One KeepAliveInterval has lapsed without any response\> |
| Negotiate                                                 |                  | XYZ            | T3            | --                    | Recoverable     | --              | 123             |
| \<New Negotiate message should contain new Session ID\>   |

\*Even though the KeepAliveInterval is part of the Establish message, generally speaking there will be a recommended value or range agreed to by the counterparties which can serve as a catch-all for these types of scenarios.

<span id="_ESTABLISHMENT_&_REESTABLISHMENT" class="anchor"><span id="_Toc429639525" class="anchor"></span></span>Binding
------------------------------------------------------------------------------------------------------------------------

### Establishment (Recoverable)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Keep Alive Interval** | **Next SeqNo** | **Server Flow** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-------------------------|----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | Recoverable     | --                      | --             | --              |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | --                      | --             | Recoverable     |
| Establish            |                     | ABC            | T2            | --                    | --              | 10                      | 1              | --              |
|                      | EstablishmentAck    | ABC            | --            | T2                    | --              | 10                      | 1              | --              |

### Establishment (Unsequenced)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Keep Alive Interval** | **Next SeqNo** | **Server Flow** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-------------------------|----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | Unsequenced     | --                      | --             | --              |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | --                      | --             | Unsequenced     |
| Establish            |                     | ABC            | T2            | --                    | --              | 10                      | --             | --              |
|                      | Establish mentAck   | ABC            | --            | T2                    | --              | 10                      | --             | --              |

### Establishment (idempotent)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Keep Alive Interval** | **Next SeqNo** | **Server Flow** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-------------------------|----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | Idempotent      | --                      | --             | --              |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | --                      | --             | Recoverable     |
| Establish            |                     | ABC            | T2            | --                    | --              | 10                      | 1              | --              |
|                      | Establish mentAck   | ABC            | --            | T2                    | --              | 10                      | 1              | --              |

### Establishment (none)

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Keep Alive Interval** | **Next SeqNo** | **Server Flow** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-------------------------|----------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | None            | --                      | --             | --              |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | --                      | --             | None            |
| Establish            |                     | ABC            | T2            | --                    | --              | 10                      | --             | --              |
|                      | Establish mentAck   | ABC            | --            | T2                    | --              | 10                      | --             | --              |

### Establishment rejects

#### Unnegotiated

For example – Trying to send an Establish message without first Negotiating the session will result in the Establishment message being rejected.

| **Message Received** | **Message Sent**      | **Session ID** | **Timestamp** | **Request Timestamp** | **Code**     | **Reason**                                    | **Keep Alive Interval** |
|----------------------|-----------------------|----------------|---------------|-----------------------|--------------|-----------------------------------------------|-------------------------|
| Establish            |                       | ABC            | T2            | --                    | --           | --                                            | 10                      |
|                      | Establish ment Reject | ABC            | --            | T2                    | Unnegotiated | Establishment Not Allowed Without Negotiation | --                      |

#### Already established

For example – Trying to send an Establish message when the session itself is already Negotiated and Established will result in the Establishment message being rejected.

| **Message Received** | **Message Sent**     | **Session ID** | **Timestamp** | **Request Timestamp** | **Code**            | **Reason**                     | **Keep Alive Interval** |
|----------------------|----------------------|----------------|---------------|-----------------------|---------------------|--------------------------------|-------------------------|
| Negotiate            |                      | ABC            | T1            | --                    | --                  | --                             | --                      |
|                      | Negotiation Response | ABC            | --            | T1                    | --                  | --                             | --                      |
| Establish            |                      | ABC            | T2            | --                    | --                  | --                             | 10                      |
|                      | Establish mentAck    | ABC            | --            | T2                    | --                  | --                             | 10                      |
| Establish            |                      | ABC            | T3            | --                    | --                  | --                             | 10                      |
|                      | Establish mentReject | ABC            | --            | T3                    | Already Established | Session is Already Established | --                      |

#### Session blocked

For example – if a particular Session ID has been blocked for bad behavior and is not allowed to establish a session with the counterparty then also the Establishment message will be rejected.

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Code**        | **Reason**                                                 | **Keep Alive Interval** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|------------------------------------------------------------|-------------------------|
| Negotiate            |                     | ABC            | T1            | --                    | --              | --                                                         | --                      |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | --                                                         | --                      |
| Establish            |                     | ABC            | T2            | --                    | --              | --                                                         | 10                      |
|                      | EstablishmentReject | ABC            | --            | T2                    | Session Blocked | Session Has Been Blocked, Please Contact Market Operations | 10                      |

#### Invalid keep alive interval

For example – if the bilateral rules of engagement permit a KeepAliveInterval no smaller than 10 milliseconds then an Establishment message sent with a KeepAliveInterval of 1 millisecond will be rejected.

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Code**           | **Reason**                 | **Keep Alive Interval** |
|----------------------|---------------------|----------------|---------------|-----------------------|--------------------|----------------------------|-------------------------|
| Negotiate            |                     | ABC            | T1            | --                    | --                 | --                         | --                      |
|                      | NegotiationResponse | ABC            | --            | T1                    | --                 | --                         | --                      |
| Establish            |                     | ABC            | T2            | --                    | --                 | --                         | 1                       |
|                      | EstablishmentReject | ABC            | --            | T2                    | KeepAlive Interval | Invalid KeepAlive Interval | 1                       |

#### Invalid session ID

For example – Session ID does not follow UUID or GUID semantics as per RFC 4122 and Establishment message is sent with Session ID as all zeros then it will be rejected.

| **Message Received** | **Message Sent**     | **Session ID** | **Timestamp** | **Request Timestamp** | **Code**    | **Reason**                | **Keep Alive Interval** |
|----------------------|----------------------|----------------|---------------|-----------------------|-------------|---------------------------|-------------------------|
| Negotiate            |                      | ABC            | T1            | --                    | --          | --                        | --                      |
|                      | Negotiation Response | ABC            | --            | T1                    | --          | --                        | --                      |
| Establish            |                      | 000            | T2            | --                    | --          | --                        | 10                      |
|                      | Establish mentReject | 000            | --            | T2                    | Unspecified | Invalid Session ID Format | 10                      |

#### Invalid request timestamp

For example – Timestamp follows Unix Epoch semantics and is to be sent with nanosecond level precision but Establishment message is sent with Timestamp as Unix Epoch but expressed as number of seconds then it will be rejected.

| **Message Received** | **Message Sent**     | **Session ID** | **Timestamp** | **Request Timestamp** | **Code**    | **Reason**               | **Keep Alive Interval** |
|----------------------|----------------------|----------------|---------------|-----------------------|-------------|--------------------------|-------------------------|
| Negotiate            |                      | ABC            | T1            | --                    | --          | --                       | --                      |
|                      | Negotiation Response | ABC            | --            | T1                    | --          | --                       | --                      |
| Establish            |                      | ABC            | 86400         | --                    | --          | --                       | 10                      |
|                      | Establish mentReject | ABC            | --            | 86400                 | Unspecified | Invalid Timestamp Format | 10                      |

#### Bad credentials

For example – Valid Credentials are 123 but Establishment message is sent with Credentials as 456 then it will be rejected.

| **Message Received** | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Code**        | **Reason**        | **Credentials** |
|----------------------|---------------------|----------------|---------------|-----------------------|-----------------|-------------------|-----------------|
| Negotiate            |                     | ABC            | T1            | --                    | --              | --                | 123             |
|                      | NegotiationResponse | ABC            | --            | T1                    | --              | --                | --              |
| Establish            |                     | ABC            | T2            | --                    | --              | --                | 456             |
|                      | EstablishmentReject | ABC            | --            | T2                    | Bad Credentials | Invalid Trader ID | --              |

#### Mismatch of SessionID/RequestTimestamp

For example – the session identifier and the request timestamp in the EstablishmentAck do not match with the Establishment message then the acknowledgment MUST be ignored and an internal alert may be generated.

| **Message Received**                                                                                                                              | **Message Sent**    | Session ID | Timestamp | Request Timestamp | Client Flow | Keep Alive Interval | Next SeqNo | Server Flow |
|---------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|------------|-----------|-------------------|-------------|---------------------|------------|-------------|
| Negotiate                                                                                                                                         |                     | ABC        | T1        | --                | Idempotent  | --                  | --         | --          |
|                                                                                                                                                   | NegotiationResponse | ABC        | --        | T1                | --          | --                  | --         | Recoverable |
| Establish                                                                                                                                         |                     | ABC        | T2        | --                | --          | 10                  | --         | --          |
|                                                                                                                                                   | Establish mentAck   | DEF        | --        | T3                | --          | 10                  | 1          | --          |
| \<Ignore EstablishmentAck message since it contains incorrect Session ID and/or RequestTimestamp and Generate Internal Alert and Possibly Retry\> |
| Establish                                                                                                                                         |                     | ABC        | T4        | --                | --          | 10                  | --         | --          |
| \<New Establish message should contain same Session ID\>                                                                                          |

#### EstablishmentAck or Reject Not Received

For example – the Establish message is neither accepted nor rejected and one KeepAliveInterval has lapsed then an internal alert may be generated followed by a new Establish message.

| **Message Received**                                      | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Server Flow** | **Credentials** | **KeepAliveInterval** |
|-----------------------------------------------------------|---------------------|----------------|---------------|-----------------------|-----------------|-----------------|-----------------|-----------------------|
| Negotiate                                                 |                     | ABC            | T1            | --                    | Idempotent      | --              | 123             |                       |
|                                                           | NegotiationResponse | ABC            | --            | T1                    | --              | Recoverable     | --              |                       |
| Establish                                                 |                     | ABC            | T2            | --                    | --              | --              | --              | 10                    |
| \<One KeepAliveInterval has lapsed without any response\> |                     |
| Establish                                                 |                     | ABC            | T3            | --                    | --              | --              | --              | 10                    |
| \<New Establish message should contain same Session ID\>  |

<span id="_termination" class="anchor"><span id="_Toc429639526" class="anchor"></span></span>Unbinding
------------------------------------------------------------------------------------------------------

### Ungraceful termination (time out)

When the KeepAliveInterval has expired and no keep alive message is received then the session is terminated ungracefully and will need to be re-established. The transport level connection is still open (TCP socket) therefore Negotiation is not required. Termination due to error does not require the sender to wait for corresponding Terminate response from counterparty.

| **Message Received**                                                                             | **Message Sent**    | **Session ID** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Keep Alive Interval** | **Code**  | **Reason**                     |
|--------------------------------------------------------------------------------------------------|---------------------|----------------|---------------|-----------------------|-----------------|-------------------------|-----------|--------------------------------|
| Negotiate                                                                                        |                     | ABC            | T1            | --                    | Idempotent      | --                      | --        | --                             |
|                                                                                                  | NegotiationResponse | ABC            | --            | T1                    | --              | --                      | --        | --                             |
| Establish                                                                                        |                     | ABC            | T2            | --                    | --              | 10                      | --        | --                             |
|                                                                                                  | Establish mentAck   | ABC            | --            | T2                    | --              | 10                      | --        | --                             |
| \<Time Interval Greater Than Keep Alive Interval Has Lapsed Without Any Message Being Received\> |
|                                                                                                  | Terminate           | ABC            | --            | --                    | --              | --                      | Timed Out | Keep Alive Interval Has Lapsed |
| Establish                                                                                        |                     | ABC            | T3            | --                    | --              | 10                      | --        | --                             |
|                                                                                                  | Establish mentAck   | ABC            | --            | T3                    | --              | 10                      | --        | --                             |
| \<New Establish message should be sent with same Session ID\>                                    |

### Ungraceful termination (sequence message received with lower sequence number)

The session could also be deliberately terminated due to Sequence message received with lower than expected sequence number and then it will need to be re-established. The transport level connection is still open (TCP socket) therefore Negotiation is not required. Termination due to error does not require the sender to wait for corresponding Terminate response from counterparty.

| **Message Received**                                          | **Message Sent**     | **Session ID** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **ImplicitSeqNo** | **Client Flow** | **Server Flow** | **Code**          | **Reason**        |
|---------------------------------------------------------------|----------------------|----------------|---------------|-----------------------|----------------|-------------------|-----------------|-----------------|-------------------|-------------------|
| Negotiate                                                     |                      | ABC            | T1            | --                    | --             | --                | Idempotent      | --              | --                | --                |
|                                                               | Negotiation Response | ABC            | --            | T1                    | --             | --                |                 | Recoverable     | --                | --                |
| Establish                                                     |                      | ABC            | T2            | --                    | 200            | --                | --              | --              | --                | --                |
|                                                               | Establish mentAck    | ABC            | --            | T2                    | 1000           | --                | --              | --              | --                | --                |
| Sequence                                                      |                      | --             | --            | --                    | 100            | --                | --              | --              | --                | --                |
|                                                               | Terminate            | ABC            | --            | --                    | --             | --                | --              | --              | Unspecified Error | Invalid NextSeqNo |
| Establish                                                     |                      | ABC            | T4            | --                    | 200            | --                | Idempotent      | --              | --                | --                |
|                                                               | Establish mentAck    | ABC            | --            | T4                    | 1001           | --                | --              | Recoverable     | --                | --                |
| \<New Establish message should be sent with same Session ID\> |

### Ungraceful termination (establishment ack received with lower sequence number)

The session could also be deliberately terminated due to EstablishmentAck message received with lower than expected sequence number and then it will need to be re-established. The transport level connection is still open (TCP socket) therefore Negotiation is not required. Termination due to error does not require the sender to wait for corresponding Terminate response from counterparty.

| **Message Received**                                         | **Message Sent**     | **Session ID** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **ImplicitSeqNo** | **Client Flow** | **Server Flow** | **Code**          | **Reason**        |
|--------------------------------------------------------------|----------------------|----------------|---------------|-----------------------|----------------|-------------------|-----------------|-----------------|-------------------|-------------------|
| Negotiate                                                    |                      | ABC            | T1            | --                    | --             | --                | Idempotent      | --              | --                | --                |
|                                                              | Negotiation Response | ABC            | --            | T1                    | --             | --                |                 | Recoverable     | --                | --                |
| Establish                                                    |                      | ABC            | T2            | --                    | 200            | --                | --              | --              | --                | --                |
|                                                              | Establish mentAck    | ABC            | --            | T2                    | 1000           | --                | --              | --              | --                | --                |
| Sequence                                                     |                      | --             | --            | --                    | 100            | --                | --              | --              | --                | --                |
|                                                              | Terminate            | ABC            | --            | --                    | --             | --                | --              | --              | Unspecified Error | Invalid NextSeqNo |
| Establish                                                    |                      | ABC            | T4            | --                    | 200            | --                | Idempotent      | --              | --                | --                |
|                                                              | Establish mentAck    | ABC            | --            | T4                    | 1001           | --                | --              | Recoverable     | --                | --                |
| \<New Establish message could be sent with same Session ID\> |

### Graceful Termination

Graceful termination is possible when there are no more messages to be sent for the time being and the TCP socket connection could be disconnected for now. This allows the sender to re-establish connectivity with the same session ID as before since the session was terminated without finalization (FinishedSending was not used to indicate logical end of flow). Graceful termination (not due to error) does require the sender to wait for corresponding Terminate response from counterparty before disconnecting TCP socket connection. The receiver should not attempt to initiate TCP socket disconnection since the sender will do that upon receiving the response.

| **Message Received**                                         | **Message Sent**     | **Session ID** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **ImplicitSeqNo** | **Client Flow** | **Server Flow** | **Code** | **Reason** |
|--------------------------------------------------------------|----------------------|----------------|---------------|-----------------------|----------------|-------------------|-----------------|-----------------|----------|------------|
| Negotiate                                                    |                      | ABC            | T1            | --                    | --             | --                | Idempotent      | --              | --       | --         |
|                                                              | Negotiation Response | ABC            | --            | T1                    | --             | --                |                 | Recoverable     | --       | --         |
| Establish                                                    |                      | ABC            | T2            | --                    | 200            | --                | --              | --              | --       | --         |
|                                                              | Establish mentAck    | ABC            | --            | T2                    | 1000           | --                | --              | --              | --       | --         |
| Sequence                                                     |                      | --             | --            | --                    | 201            | --                | --              | --              | --       | --         |
| Terminate                                                    |                      | ABC            | --            | --                    | --             | --                | --              | --              | Finished | --         |
|                                                              | Terminate            | ABC            | --            | --                    | --             | --                | --              | --              | Finished | --         |
| \<TCP socket connection is disconnected by sender\>          |
| Establish                                                    |                      | ABC            | T4            | --                    | 200            | --                | Idempotent      | --              | --       | --         |
|                                                              | Establish mentAck    | ABC            | --            | T4                    | 1001           | --                | --              | Recoverable     | --       | --         |
| \<New Establish message could be sent with same Session ID\> |

### Disconnection

When the transport level session itself (TCP socket) has been disconnected then the session needs to be Negotiated and Established.

| **Message Received**                              | **Message Sent**    | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Client Flow** | **Keep Alive Interval** | **Server Flow** | **Reason** |
|---------------------------------------------------|---------------------|-----------------------|---------------|-----------------------|-----------------|-------------------------|-----------------|------------|
| Negotiate                                         |                     | ABC                   | T1            | --                    | Idempotent      | --                      | --              | --         |
|                                                   | NegotiationResponse | ABC                   | --            | T1                    | --              | --                      | Recoverable     | --         |
| Establish                                         |                     | ABC                   | T2            | --                    | --              | 10                      | --              | --         |
|                                                   | Establish mentAck   | ABC                   | --            | T2                    | --              | 10                      | --              | --         |
| \<TCP socket connection is disconnected\>         |
| Negotiate                                         |                     | DEF                   | T3            | --                    | Idempotent      | --                      | --              | --         |
|                                                   | NegotiationResponse | DEF                   | --            | T3                    | --              | --                      | Recoverable     | --         |
| Establish                                         |                     | DEF                   | T4            | --                    | --              | 10                      | --              | --         |
|                                                   | Establish mentAck   | DEF                   | --            | T4                    | --              | 10                      | --              | --         |
| \<New Negotiate message requires new Session ID\> |

<span id="_sequence" class="anchor"><span id="_Toc429639527" class="anchor"></span></span>Transferring
------------------------------------------------------------------------------------------------------

### Sequence

Over TCP – a Client could send a Sequence message at the very beginning of the session upon establishment. The counterparty would not use it initially as it is provided in the EstablishmentAck message.

| **Message Received** | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **Client Flow** | **Server Flow** | ** Implicit SeqNo** |
|----------------------|----------------------|-----------------------|---------------|-----------------------|----------------|-----------------|-----------------|---------------------|
| Negotiate            |                      | ABC                   | T1            | --                    | --             | Idempotent      |                 | --                  |
|                      | Negotiation Response | ABC                   | --            | T1                    | --             |                 | Recoverable     | --                  |
| Establish            |                      | ABC                   | T2            | --                    | 100            |                 |                 | --                  |
|                      | EstablishmentAck     | ABC                   | --            | T2                    | 1000           |                 |                 | --                  |
| Sequence             |                      | --                    | --            | --                    | 100            |                 |                 | --                  |
| NewOrder Single      |                      | ABC                   | T3            | --                    | --             | --              | --              | 100                 |
|                      | ExecutionReport      | ABC                   | T4            | --                    | --             | --              | --              | 1000                |

Sequence message is applicable for idempotent and recoverable flows and if received for unsequenced and none flows then issue terminate message to sender since it is a protocol violation.

#### Sequence (Higher sequence number)

The Sequence, Context, EstablishmentAck and Retransmission messages are sequence forming. They turn the message flow into a sequenced mode since they have the next implicit sequence number. Any other Session message makes the flow leave the sequenced mode. If the message is sequence forming then the flow does not leave the sequenced mode, but the message potentially resets the sequence numbering.

For example – here the second Sequence message is increasing the NextSeqNo even though it was sent as a keep alive message within a sequenced flow.

| **Message Received** | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Client Flow** | **Server Flow** | **From SeqNo** | **Count** |
|----------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------------|-----------------|-----------------|----------------|-----------|
| Negotiate            |                      | ABC                   | T1            | --                    | --             | --                  | Idempotent      | --              | --             | --        |
|                      | Negotiation Response | ABC                   | --            | T1                    | --             | --                  | --              | Recoverable     | --             | --        |
| Establish            |                      | ABC                   | T2            | --                    | 100            | --                  | --              | --              | --             | --        |
|                      | Establishment Ack    | ABC                   | --            | T2                    | 1000           | --                  | --              | --              | --             | --        |
| Sequence             |                      | --                    | --            | --                    | 100            | --                  | --              | --              | --             | --        |
| NewOrderSingle       |                      | ABC                   | T3            | --                    | --             | 100                 | --              | --              | --             | --        |
|                      | Execution Report     | ABC                   | T4            | --                    | --             | 1000                | --              | --              | --             | --        |
| Sequence             |                      | --                    | --            | --                    | 200            | --                  | --              | --              | --             | --        |
| NewOrderSingle       |                      | ABC                   | T5            | --                    | --             | 200                 | --              | --              | --             | --        |
|                      | NotApplied           | --                    | --            | --                    | --             | --                  | --              | --              | 101            | 100       |
|                      | Execution Report     | ABC                   | T6            | --                    | --             | 1001                | --              | --              | --             | --        |

#### Sequence (Lower sequence number)

This is an example of a Sequence message being sent with a lower than expected NextSeqNo value even though it was sent as a keep alive message within a sequenced flow.

| **Message Received** | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Client Flow** | **Server Flow** | **Code**          | **Reason**        |
|----------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------------|-----------------|-----------------|-------------------|-------------------|
| Negotiate            |                      | ABC                   | T1            | --                    | --             | --                  | Idempotent      | --              | --                | --                |
|                      | Negotiation Response | ABC                   | --            | T1                    | --             | --                  | --              | Recoverable     | --                | --                |
| Establish            |                      | ABC                   | T2            | --                    | 100            | --                  | --              | --              | --                | --                |
|                      | EstablishmentAck     | ABC                   | --            | T2                    | 1000           | --                  | --              | --              | --                | --                |
| Sequence             |                      | --                    | --            | --                    | 100            | --                  | --              | --              | --                | --                |
| NewOrderSingle       |                      | ABC                   | T3            | --                    | --             | 100                 | --              | --              | --                | --                |
|                      | ExecutionReport      | ABC                   | T4            | --                    | --             | 1000                | --              | --              | --                | --                |
| Sequence             |                      | --                    | --            | --                    | 50             | --                  | --              | --              | --                | --                |
|                      | Terminate            | ABC                   | --            | --                    | --             | --                  | --              | --              | Unspecified Error | Invalid NextSeqNo |

#### Sequence (heartbeat)

The Sequence message could also be used as a heartbeat for idempotent and recoverable flows.

| **Message Received** | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **Client Flow** | **Server Flow** | **Keep Alive Interval** | ** Implicit SeqNo** |
|----------------------|----------------------|-----------------------|---------------|-----------------------|----------------|-----------------|-----------------|-------------------------|---------------------|
| Negotiate            |                      | ABC                   | T1            | --                    | --             | Idempotent      | --              | --                      | --                  |
|                      | Negotiation Response | ABC                   | --            | T1                    | --             |                 | Recoverable     | --                      | --                  |
| Establish            |                      | ABC                   | T2            | --                    | 100            | --              | --              | 10                      | --                  |
|                      | EstablishmentAck     | ABC                   | --            | T2                    | 1000           | --              | --              | 10                      | --                  |
| Sequence             |                      | --                    | -- (T2+10)    | --                    | 100            | --              | --              | --                      | --                  |
|                      | Sequence             | --                    | -- (T2+11)    | --                    | 1000           | --              | --              | --                      | --                  |
| Sequence             |                      | --                    | -- (T2+20)    | --                    | 100            | --              | --              | --                      | --                  |
|                      | Sequence             | --                    | -- (T2+21)    | --                    | 1000           | --              | --              | --                      | --                  |

### Context (Multiplexing Session ID’s)

The Context message is needed to convey that a context switch is taking place from one Session ID (ABC) to another (DEF) over the same transport. This way – two sessions (ABC & DEF) could be multiplexed over one TCP connection and there is a one to one relation between the two such that they need to be negotiated and established independently. They will have independent sequence numbering and the value of NextSeqNo in each EstablishmentAck response will depend on where the particular session is sequence wise. There is no need to send a Context message before an application message if the previous application message was destined for the same session. A Context message has to be sent before an application message if the previous application message was destined for another session. This is an example where a Context message is necessary since the previous message was for a different session.

<span id="_multiplexing_sessions" class="anchor"></span>

| **Message Received** | **Message Sent**    | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next Seq No** | ** Implicit SeqNo** |
|----------------------|---------------------|-----------------------|---------------|-----------------------|-----------------|---------------------|
| Negotiate            |                     | ABC                   | T1            | --                    | --              | --                  |
|                      | NegotiationResponse | ABC                   | --            | T1                    | --              | --                  |
| Establish            |                     | ABC                   | T2            | --                    | --              | --                  |
|                      | EstablishmentAck    | ABC                   | --            | T2                    | 1000            | --                  |
| Negotiate            |                     | DEF                   | T3            | --                    | --              | --                  |
|                      | NegotiationResponse | DEF                   | --            | T3                    | --              | --                  |
| Establish            |                     | DEF                   | T4            | --                    | --              | --                  |
|                      | EstablishmentAck    | DEF                   | --            | T4                    | 2000            | --                  |
| Context              |                     | ABC                   | --            | --                    | 100             | --                  |
| NewOrder Single      |                     | ABC                   | T5            | --                    | --              | 100                 |
|                      | Context             | ABC                   | --            | --                    | 1000            | --                  |
|                      | ExecutionReport     | ABC                   | T6            | --                    | --              | 1000                |
| Context              |                     | DEF                   | --            | --                    | 200             | --                  |
| NewOrder Single      |                     | DEF                   | T7            | --                    | --              | 200                 |
|                      |  Context            | DEF                   | --            | --                    | 2000            | --                  |
|                      | ExecutionReport     | DEF                   | T8            | --                    | --              | 2000                |

#### Context flow using sequence

This is an example where a Context message is not necessary since the previous message was for the same session and a Sequence message will suffice.

| **Message Received** | **Message Sent**    | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** |
|----------------------|---------------------|-----------------------|---------------|-----------------------|----------------|---------------------|
| Negotiate            |                     | ABC                   | T1            | --                    | --             | --                  |
|                      | NegotiationResponse | ABC                   | --            | T1                    | --             | --                  |
| Establish            |                     | ABC                   | T2            | --                    | --             | --                  |
|                      | EstablishmentAck    | ABC                   | --            | T2                    | 1000           | --                  |
| Sequence             |                     | --                    | --            | --                    | 100            | --                  |
| NewOrder Single      |                     | ABC                   | T3            | --                    | --             | 100                 |
|                      | ExecutionReport     | ABC                   | T4            | --                    | --             | 1000                |
| Negotiate            |                     | DEF                   | T5            | --                    | --             | --                  |
|                      | NegotiationResponse | DEF                   | --            | T5                    | --             | --                  |
| Establish            |                     | DEF                   | T6            | --                    | --             | --                  |
|                      | EstablishmentAck    | DEF                   | --            | T6                    | 2000           | --                  |
| Sequence             |                     | --                    | --            | --                    | 200            | --                  |
| NewOrder Single      |                     | DEF                   | T7            | --                    | --             | 200                 |
|                      | ExecutionReport     | DEF                   | T8            | --                    | --             | 2000                |

### Unsequenced Heartbeat

This message is used to keep alive the session on unsequenced and none flows.

| **Message Received** | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **Client Flow** | **Server Flow** | **Keep Alive Interval** | ** Implicit SeqNo** |
|----------------------|----------------------|-----------------------|---------------|-----------------------|----------------|-----------------|-----------------|-------------------------|---------------------|
| Negotiate            |                      | ABC                   | T1            | --                    | --             | Unsequenced     | --              | --                      | --                  |
|                      | Negotiation Response | ABC                   | --            | T1                    | --             |                 | Recoverable     | --                      | --                  |
| Establish            |                      | ABC                   | T2            | --                    | 100            | --              | --              | 10                      | --                  |
|                      | EstablishmentAck     | ABC                   | --            | T2                    | 1000           | --              | --              | 10                      | --                  |
| UnsequencedHeartbeat |                      | --                    | -- (T2+10)    | --                    | --             | --              | --              | --                      | --                  |
| UnsequencedHeartbeat |                      | --                    | -- (T2+20)    | --                    | --             | --              | --              | --                      | --                  |
| UnsequencedHeartbeat |                      | --                    | -- (T2+30)    | --                    | --             | --              | --              | --                      | --                  |

### Retransmission Request

For recoverable flows, a Retransmission Request could be issued to recover gap in sequence numbers

| **Message Received**                                                                                                                  | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Client Flow** | **Server Flow** | **From SeqNo** | **Count** |
|---------------------------------------------------------------------------------------------------------------------------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------------|-----------------|-----------------|----------------|-----------|
| Negotiate                                                                                                                             |                      | ABC                   | T1            | --                    | --             | --                  | Idempotent      | --              | --             | --        |
|                                                                                                                                       | Negotiation Response | ABC                   | --            | T1                    | --             | --                  | --              | Recoverable     | --             | --        |
| Establish                                                                                                                             |                      | ABC                   | T2            | --                    | 100            | --                  | --              | --              | --             | --        |
|                                                                                                                                       | Establishment Ack    | ABC                   | --            | T2                    | 1000           | --                  | --              | --              | --             | --        |
|                                                                                                                                       | Sequence             | --                    | --            | --                    | 1000           | --                  | --              | --              | --             | --        |
|                                                                                                                                       | Execution Report     | ABC                   | T3            | --                    | --             | 1100                | --              | --              | --             | --        |
| RetransmissionRequest                                                                                                                 |                      | ABC                   | T4            | --                    | --             | --                  | --              | --              | 1000           | 100       |
|                                                                                                                                       | Retransmission       | ABC                   | --            | T4                    | 1000           | --                  | --              | --              | --             | 100       |
| \<100 messages between 1000 to 1099 are replayed and message number 1100 is queued for processing after Retransmisison is satisfied\> |

Retransmission message is not applicable for idempotent, unsequenced and none flows and if received for these flows then issue terminate message to sender since it is a protocol violation.

#### Retransmission (Concurrent)

More than one RetransmissionRequest is not allowed at a time and subsequent in-flight requests will lead to session termination.

| **Message Received**                                            | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Client Flow** | **Server Flow** | **From SeqNo** | **Count** |
|-----------------------------------------------------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------------|-----------------|-----------------|----------------|-----------|
| Negotiate                                                       |                      | ABC                   | T1            | --                    | --             | --                  | Idempotent      | --              | --             | --        |
|                                                                 | Negotiation Response | ABC                   | --            | T1                    | --             | --                  | --              | Recoverable     | --             | --        |
| Establish                                                       |                      | ABC                   | T2            | --                    | 100            | --                  | --              | --              | --             | --        |
|                                                                 | Establishment Ack    | ABC                   | --            | T2                    | 1000           | --                  | --              | --              | --             | --        |
|                                                                 | Sequence             | --                    | --            | --                    | 1000           | --                  | --              | --              | --             | --        |
|                                                                 | Execution Report     | ABC                   | T3            | --                    | --             | 1100                | --              | --              | --             | --        |
| RetransmissionRequest                                           |                      | ABC                   | T4            | --                    | --             | --                  | --              | --              | 1000           | 100       |
|                                                                 | Retransmission       | ABC                   | --            | T4                    | 1000           | --                  | --              | --              | --             | 100       |
| \<50 messages between 1000 and 1099 are replayed\>              |
| RetransmissionRequest                                           |                      | ABC                   | T5            | --                    | --             | --                  | --              | --              | 1050           | 50        |
|                                                                 | Terminate            | ABC                   | --            | --                    | --             | --                  | --              | --              | --             | --        |
| \<Session terminated with TerminationCode=ReRequestInProgress\> |

#### Retransmission (Interleaving)

While responding back to a RetransmissionRequest it is possible that the sender could interleave real time original messages with duplicate retransmission responses. This interleaving will happen between both flows in ranges which could be the chunk of messages which can fit into a single datagram or packet. Each batch of duplicate replayed messages will be preceded by a Retransmission message in the same packet and each batch of real time original messages will be preceded by a Sequence message in the same packet.

| **Message Received**                                                                                                           | **Message Sent** | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Client Flow** | **Server Flow** | **From SeqNo** | **Count** |
|--------------------------------------------------------------------------------------------------------------------------------|------------------|-----------------------|---------------|-----------------------|----------------|---------------------|-----------------|-----------------|----------------|-----------|
| RetransmissionRequest                                                                                                          |                  | ABC                   | T1            | --                    | --             | --                  | --              | --              | 1000           | 100       |
|                                                                                                                                | Retransmission   | ABC                   | --            | T1                    | 1000           | --                  | --              | --              | --             | 50        |
| \<50 duplicate messages between 1000 and 1049 are replayed in first packet which includes Retransmission message\>             
                                                                                                                                 
 \<Real time messages between 2000 and 2049 are queued by the sender at this time\>                                              |
|                                                                                                                                | Sequence         | --                    | --            | --                    | 2000           | --                  | --              | --              | --             | --        |
| \<50 original real time messages between 2000 and 2049 are sent in second packet which includes Sequence message\>             
                                                                                                                                 
 \<Duplicate messages between 1050 and 1099 are queued by sender at this time\>                                                  |
|                                                                                                                                | Retransmission   | ABC                   | --            | T1                    | 1050           | --                  | --              | --              | --             | 50        |
| \<Second batch of 50 duplicate messages between 1050 and 1099 are send in third packet which includes Retransmission message\> |

### Retransmission Reject

#### Invalid FromSeqNo

RetransmissionRequest could be rejected if the messages being requested (FromSeqNo) belong to an invalid sequence range i.e. greater than last sent sequence number from sender.

| **Message Received**                                                   | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Code**   | **Reason**        | **From SeqNo** | **Count** |
|------------------------------------------------------------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------------|------------|-------------------|----------------|-----------|
| Negotiate                                                              |                      | ABC                   | T1            | --                    | --             | --                  | Idempotent | --                | --             | --        |
|                                                                        | Negotiation Response | ABC                   | --            | T1                    | --             | --                  | --         | Recoverable       | --             | --        |
| Establish                                                              |                      | ABC                   | T2            | --                    | 100            | --                  | --         | --                | --             | --        |
|                                                                        | Establishment Ack    | ABC                   | --            | T2                    | 1000           | --                  | --         | --                | --             | --        |
|                                                                        | Sequence             | --                    | --            | --                    | 1000           | --                  | --         | --                | --             | --        |
| RetransmissionRequest                                                  |                      | ABC                   | T3            | --                    | --             | --                  | --         | --                | 2000           | 100       |
|                                                                        | RetransmitReject     | ABC                   | --            | T3                    | --             | --                  | OutOfRange | Invalid FromSeqNo | --             | --        |
| \<Here FromSeqNo is greater than last value of NextSeqNo from sender\> |

#### Retransmission Reject (OutOfRange)

RetransmissionRequest could be rejected if the messages being requested (FromSeqNo + Count) belong to an invalid sequence range i.e. greater than last sent sequence number from sender.

| **Message Received**                                                           | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Code**   | **Reason**    | **From SeqNo** | **Count** |
|--------------------------------------------------------------------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------------|------------|---------------|----------------|-----------|
| Negotiate                                                                      |                      | ABC                   | T1            | --                    | --             | --                  | Idempotent | --            | --             | --        |
|                                                                                | Negotiation Response | ABC                   | --            | T1                    | --             | --                  | --         | Recoverable   | --             | --        |
| Establish                                                                      |                      | ABC                   | T2            | --                    | 100            | --                  | --         | --            | --             | --        |
|                                                                                | Establishment Ack    | ABC                   | --            | T2                    | 1000           | --                  | --         | --            | --             | --        |
|                                                                                | Sequence             | --                    | --            | --                    | 1000           | --                  | --         | --            | --             | --        |
| RetransmissionRequest                                                          |                      | ABC                   | T3            | --                    | --             | --                  | --         | --            | 900            | 175       |
|                                                                                | RetransmitReject     | ABC                   | --            | T3                    | --             | --                  | OutOfRange | Invalid Range | --             | --        |
| \<Here FromSeqNo + Count is greater than last value of NextSeqNo from sender\> |

#### Retransmission Reject (Invalid Session ID)

RetransmissionRequest could be rejected if the messages are being requested with a different session ID such that it is unknown or not authorized.

| **Message Received**                                                                        | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Code**        | **Reason**         | **From SeqNo** | **Count** |
|---------------------------------------------------------------------------------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------------|-----------------|--------------------|----------------|-----------|
| Negotiate                                                                                   |                      | ABC                   | T1            | --                    | --             | --                  | Idempotent      | --                 | --             | --        |
|                                                                                             | Negotiation Response | ABC                   | --            | T1                    | --             | --                  | --              | Recoverable        | --             | --        |
| Establish                                                                                   |                      | ABC                   | T2            | --                    | 100            | --                  | --              | --                 | --             | --        |
|                                                                                             | Establishment Ack    | ABC                   | --            | T2                    | 1000           | --                  | --              | --                 | --             | --        |
|                                                                                             | Sequence             | --                    | --            | --                    | 1000           | --                  | --              | --                 | --             | --        |
| RetransmissionRequest                                                                       |                      | DEF                   | T3            | --                    | --             | --                  | --              | --                 | 850            | 50        |
|                                                                                             | RetransmitReject     | DEF                   | --            | T3                    | --             | --                  | Invalid Session | Unknown Session ID | --             | --        |
| \<Here DEF is an unknown session ID since it has not negotiated and established a session\> |

#### Retransmission Reject (Request Limit Exceeded)

RetransmissionRequest could be rejected if the messages being requested exceed the limit for allowable count in each request.

| **Message Received**                                                                                                                      | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | ** Implicit SeqNo** | **Code**             | **Reason**        | **From SeqNo** | **Count** |
|-------------------------------------------------------------------------------------------------------------------------------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------------|----------------------|-------------------|----------------|-----------|
| Negotiate                                                                                                                                 |                      | ABC                   | T1            | --                    | --             | --                  | Idempotent           | --                | --             | --        |
|                                                                                                                                           | Negotiation Response | ABC                   | --            | T1                    | --             | --                  | --                   | Recoverable       | --             | --        |
| Establish                                                                                                                                 |                      | ABC                   | T2            | --                    | 100            | --                  | --                   | --                | --             | --        |
|                                                                                                                                           | Establishment Ack    | ABC                   | --            | T2                    | 1000           | --                  | --                   | --                | --             | --        |
|                                                                                                                                           | Sequence             | --                    | --            | --                    | 1000           | --                  | --                   | --                | --             | --        |
| RetransmissionRequest                                                                                                                     |                      | ABC                   | T3            | --                    | --             | --                  | --                   | --                | 1              | 999       |
|                                                                                                                                           | RetransmitReject     | ABC                   | --            | T3                    | --             | --                  | RequestLimitExceeded | Count Exceeds 500 | --             | --        |
| \<Here the RetransmisisonRequest was rejected due to the count of messages requested bring greater than what is supported by the sender\> |

#### Retransmission Reject (Retrasmission Out of Bounds)

RetransmissionRequest asking to replay messages which are no longer available (for example older than three days) could also be rejected.

| **Message Received**                                                   | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **ImplicitSeqNo** | **From SeqNo** | **Count** | **Code**             | **Reason**                   |
|------------------------------------------------------------------------|----------------------|-----------------------|---------------|-----------------------|----------------|-------------------|----------------|-----------|----------------------|------------------------------|
| Negotiate                                                              |                      | ABC                   | T1            | --                    | --             | --                | --             | --        | --                   | --                           |
|                                                                        | Negotiation Response | ABC                   | --            | T1                    | --             | --                | --             | --        | --                   | --                           |
| Establish                                                              |                      | ABC                   | T2            | --                    | 200            | --                | --             | --        | --                   | --                           |
|                                                                        | Establish mentAck    | ABC                   | --            | T2                    | 1000           | --                | --             | --        | --                   | --                           |
| RetransmitRequest                                                      |                      | ABC                   | T3            | --                    | --             | --                | 1              | 175       | --                   | --                           |
|                                                                        | RetransmitReject     | ABC                   | --            | T3                    | --             | --                | --             | --        | ReRequestOutOfBounds | Messages No Longer Available |
| \<Here the messages being requested (1-175) were older than 72 hours\> |

Finalizing
----------

### Finished Sending & Finished Receiving

The FinishedSending message is used by the initiator to inform the acceptor that the logical flow of messages has reached its end i.e. the FIXP session is in the process of being wound down and gracefully terminated, for example at the end of the day or at the end of the week etc. Once the acceptor responds back with a FinishedReceiving confirmation message then the session could be half-closed i.e. no more messages will be sent from the initiator but the acceptor could continue to send messages until it does not send a FinishedSending message itself to the counterparty to indicate that it too has reached the end of its logical flow and it has no more messages to send.

The FinishedReceiving message is used to confirm that the FinishedSending message has been successfully received and acknowledged and that the FIXP session could be terminated once both counterparties have sent and received a FinishedReceiving message. The initiator is then expected to re-negotiate the session with a new SessionID.

| **Message Received**                                                                                                                                                                                                                                                    | **Message Sent**     | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **LastSeqNo** | **ClientFlow** | **ServerFlow** | **Code** | **Reason** |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------|-----------------------|---------------|-----------------------|----------------|---------------|----------------|----------------|----------|------------|
| Negotiate                                                                                                                                                                                                                                                               |                      | ABC                   | T1            | --                    | --             | --            | Idempotent     | --             | --       | --         |
|                                                                                                                                                                                                                                                                         | Negotiation Response | ABC                   | --            | T1                    | --             | --            | --             | Recoverable    | --       | --         |
| Establish                                                                                                                                                                                                                                                               |                      | ABC                   | T2            | --                    | 200            | --            | ---            | --             | --       | --         |
|                                                                                                                                                                                                                                                                         | Establish mentAck    | ABC                   | --            | T2                    | 1000           | --            | --             | --             | --       | --         |
| NewOrderSingle                                                                                                                                                                                                                                                          |                      | ABC                   | T3            | --                    | --             | --            | --             | --             | --       | --         |
|                                                                                                                                                                                                                                                                         | EecutionReport       | ABC                   | --            | T3                    | --             | --            | --             | --             | --       | --         |
| FinishedSending                                                                                                                                                                                                                                                         |                      | ABC                   | --            | --                    | --             | 201           | --             | --             | --       | --         |
|                                                                                                                                                                                                                                                                         | FinishedReceiving    | ABC                   | --            | --                    | --             | --            | --             | --             | --       | --         |
|                                                                                                                                                                                                                                                                         | FinishedSending      | ABC                   | --            | --                    | --             | 1001          | --             | --             | --       | --         |
| FinishedReceiving                                                                                                                                                                                                                                                       |                      | ABC                   | --            | --                    | --             | --            | --             | --             | --       | --         |
| Terminate                                                                                                                                                                                                                                                               |                      | ABC                   | --            | --                    | --             | --            | --             | --             | Finished | --         |
|                                                                                                                                                                                                                                                                         | Terminate            | ABC                   | --            | --                    | --             | --            | --             | --             | Finished | --         |
| Here the initiator has sent the Terminate message but either counterparty could have sent it since both have sent and received a FinishedReceiving message. The TCP socket connection is disconnected by the initiator upon receipt of the corresponding Terminate ack. |
| Negotiate                                                                                                                                                                                                                                                               |                      | DEF                   | T4            | --                    | --             | --            | --             | --             | --       | --         |
|                                                                                                                                                                                                                                                                         | NegotiationResponse  | DEF                   | --            | T4                    | --             | --            | --             | --             | --       | --         |

### Finished Sending & No Response Received

If the initiator has sent a FinishedSending message and does not receive a corresponding FinishedReceiving response from the counterparty within one KeepAliveInterval then it is supposed to keep sending the FinishedSending message until it hears back at the rate of one per KeepAliveInterval i.e. use it as a proxy for the Heartbeat message.

| **Message Received**                                                                                                                                                                                                                                                                                                                         | **Message Sent**  | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **LastSeqNo** | **Code** | **Reason** |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|-----------------------|---------------|-----------------------|----------------|---------------|----------|------------|
| FinishedSending                                                                                                                                                                                                                                                                                                                              |                   | ABC                   | --            | --                    | --             | 201           | --       | --         |
| One \<KeepAliveInterval\> lapses without any corresponding FinishedReceived response from the counterparty                                                                                                                                                                                                                                   |                   |                       |
| FinishedSending                                                                                                                                                                                                                                                                                                                              |                   | ABC                   | --            | --                    | --             | 201           | --       | --         |
| One \<KeepAliveInterval\> lapses without any corresponding FinishedReceived response from the counterparty                                                                                                                                                                                                                                   |                   |                       |
| FinishedSending                                                                                                                                                                                                                                                                                                                              |                   | ABC                   | --            | --                    | --             | 201           | --       | --         |
|                                                                                                                                                                                                                                                                                                                                              | FinishedReceiving | ABC                   | --            | --                    | --             | --            |          |            |
| Even though multiple \<FinishedSending\> messages have been sent, a single \<FinishedReceiving\> response is sufficient to assume that the session could be terminated i.e. there is no need to wait for separate \<FinishedReceving\> responses for each \<FinishedSending\> request sent and the initiator could now terminate the session |

### Finished Sending & Recoverable Flow

Upon receiving the FinishedSending message, if the counterparty detects a gap in the sequence by scrutinizing the \<LastSeqNo\> field (which is literal and not implied) then it will attempt to recover this gap in a recoverable flow before responding back with a corresponding FinishedReceiving confirmation message.

| **Message Received**                                                                                                                                                                                                                                                                                                             | **Message Sent**      | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **LastSeqNo** | **FromSeqNo** | **Count** | **Code** |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------|-----------------------|---------------|-----------------------|----------------|---------------|---------------|-----------|----------|
| FinishedSending                                                                                                                                                                                                                                                                                                                  |                       | ABC                   | --            | --                    | --             | 201           | --            | --        | --       |
| Last implicit sequence number or value of \<NextSeqNo\> from ABC is 198 therefore acceptor issues a \<RetransmissionRequest\> to recover sequence gap of four messages (198-201) assuming that ABC was using recoverable flow                                                                                                    | --                    |
|                                                                                                                                                                                                                                                                                                                                  | RetransmissionRequest | ABC                   | T1            | --                    | --             | --            | 198           | 4         | --       |
| Retransmit                                                                                                                                                                                                                                                                                                                       |                       | ABC                   | --            | T1                    | 198            | --            | --            | 4         | --       |
| Initiator replays messages in requested sequence range between 198-201 and acceptor processes these messages and responds back with corresponding acknowledgements. The initiator should be ready to process these acknowledgements from acceptor in response to retransmission even after sending a \<FinishedSending\> message |
|                                                                                                                                                                                                                                                                                                                                  | FinishedReceiving     | ABC                   | --            | --                    | --             | --            | --            | --        | --       |
| Since the acceptor’s retransmission request has been satisfied, it then proceeds to reply back with a \<FinishedReceiving\> message so that the initiator’s logical flow of messages could cease.                                                                                                                                | --                    |

### Finished Sending & Termination

The party which wishes to cease logical flow of messages from its connection at the end of the day, end of the week or upon market close should wait until the other counterparty is also ready to do the same before attempting to terminate the connection otherwise this will be regarded as a protocol violation and will result in an ungraceful termination of the connection by the other party which has not yet had the opportunity to cease logical flow of its own messages.

| **Message Received** | **Message Sent**  | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **LastSeqNo** | **FromSeqNo** | **Count** | **Code**          | **Reason**               |
|----------------------|-------------------|-----------------------|---------------|-----------------------|----------------|---------------|---------------|-----------|-------------------|--------------------------|
| FinishedSending      |                   | ABC                   | --            | --                    | --             | 201           | --            | --        | --                | --                       |
|                      | FinishedReceiving | ABC                   | --            | --                    | --             | --            | --            | --        | --                | --                       |
| Terminate            |                   | ABC                   | --            | --                    | --             | --            | --            | --        | Finished          | --                       |
|                      | Terminate         | ABC                   | --            | --                    | --             | --            | --            | --        | Unspecified Error | Logical Flow Interrupted |

### Finished Sending & Further Message Flow

The party which wishes to cease logical flow of messages from its connection at the end of the day, end of the week or upon market close should not send any other message after the first FinishedSending message has been sent. The only exception to this rule is the Retransmission message and replayed messages (in response to RetransmissionRequest from counterparty if it detects a gap based on the value of LastSeqNo). If it sends any other message either (FIXP or application) then it will lead to ungraceful termination by the other counterparty since this is a protocol violation. This should be avoided at all costs since if the other counterparty is trying to recover a gap in sequence then that will be aborted.

| **Message Received**                                                                                                                                      | **Message Sent**  | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **LastSeqNo** | **FromSeqNo** | **Count** | **Code**          | **Reason**                                    |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|-----------------------|---------------|-----------------------|----------------|---------------|---------------|-----------|-------------------|-----------------------------------------------|
| FinishedSending                                                                                                                                           |                   | ABC                   | --            | --                    | --             | 201           | --            | --        | --                | --                                            |
|                                                                                                                                                           | FinishedReceiving | ABC                   | --            | --                    | --             | --            | --            | --        | --                | --                                            |
| Sequence                                                                                                                                                  |                   | ABC                   | --            | --                    | 202            | --            | --            | --        | --                | --                                            |
|                                                                                                                                                           | Terminate         | ABC                   | --            | --                    | --             | --            | --            | --        | Unspecified Error | Logical Flow Cannot Resume After Finalization |
| Here a Sequence message was sent after the counterparty responded back with a Finished Receiving message and it led to an ungraceful termination          |
| Message Received                                                                                                                                          | Message Sent      | Session ID (UUID)     | Timestamp     | Request Timestamp     | Next SeqNo     | LastSeqNo     | FromSeqNo     | Count     | Code              | Reason                                        |
| FinishedSending                                                                                                                                           |                   | ABC                   | --            | --                    | --             | 201           | --            | --        | --                | --                                            |
| Sequence                                                                                                                                                  |                   | ABC                   | --            | --                    | 202            | --            | --            | --        | --                | --                                            |
|                                                                                                                                                           | Terminate         | ABC                   | --            | --                    | --             | --            | --            | --        | Unspecified Error | Logical Flow Cannot Resume After Finalization |
| Here a Sequence message was sent before the counterparty could respond back with a Finished Receiving message and it too led to an ungraceful termination |

### Finished Sending & Half-Close

Once one of the two parties has ceased logical flow of messages from its connection at the end of the day, end of the week or upon market close then it should still be ready and able to accept messages from the other counterparty till the time that the counterparty itself does not cease logical flow of messages from its own connection. However this should not lead to any corresponding output back from the connection which has been half-closed (with the exception of Retransmission) since that would be a protocol violation and lead to ungraceful termination.

| **Message Received**                                                                                                                                                                                                                                                                                                                                                          | **Message Sent**  | **Session ID (UUID)** | **Timestamp** | **Request Timestamp** | **Next SeqNo** | **LastSeqNo** | **ClientFlow** | **ServerFlow** | **Code**           | **Reason**                                       |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|-----------------------|---------------|-----------------------|----------------|---------------|----------------|----------------|--------------------|--------------------------------------------------|
| FinishedSending                                                                                                                                                                                                                                                                                                                                                               |                   | ABC                   | --            | --                    | --             | 201           | --             | --             | --                 | --                                               |
|                                                                                                                                                                                                                                                                                                                                                                               | FinishedReceiving | ABC                   | --            | --                    | --             | --            | --             | --             | --                 | --                                               |
|                                                                                                                                                                                                                                                                                                                                                                               | EecutionReport    | ABC                   | --            | T5                    | --             | --            | --             | --             | --                 | --                                               |
|                                                                                                                                                                                                                                                                                                                                                                               | EecutionReport    | ABC                   | --            | T6                    | --             | --            | --             | --             | --                 | --                                               |
| RetransmissionRequest                                                                                                                                                                                                                                                                                                                                                         |                   | ABC                   | T7            | --                    | --             | --            | --             | --             | --                 | --                                               |
|                                                                                                                                                                                                                                                                                                                                                                               | Terminate         | ABC                   | --            | --                    | --             | --            | --             | --             | FUnspecified Error | -- Logical Flow Cannot Resume After Finalization |
| Here the initiator has sent a RetransmissionRequest message after ceasing logical flow of messages from its own connection while continuing to accept message flow from acceptor and this will result in an ungraceful termination since the initiator can only respond back to a RetransmisisonRequest but cannot initiate one of its own after half-closing its connection. |
