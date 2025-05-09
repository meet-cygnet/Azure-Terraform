import threading
import time
from azure.eventhub import EventHubProducerClient, EventData
from azure.eventhub import EventHubConsumerClient

# ----------- Configuration (replace with your values) -----------
CONNECTION_STR = "Endpoint=sb://abc-eventhub-namespace.servicebus.windows.net/;SharedAccessKeyName=send-read;SharedAccessKey=OgqJAJe1wqtW4A1fb/V5xaq2Q22waYxxc+AEhGom++4=;EntityPath=stream1"
EVENTHUB_NAME = "stream1"
CONSUMER_GROUP = "$Default"
TEST_MESSAGE = "Hello from private endpoint!"
# ---------------------------------------------------------------

def send_message():
    print("[Sender] Connecting...")
    producer = EventHubProducerClient.from_connection_string(conn_str=CONNECTION_STR, eventhub_name=EVENTHUB_NAME)
    event_data_batch = producer.create_batch()
    event_data_batch.add(EventData(TEST_MESSAGE))
    producer.send_batch(event_data_batch)
    print(f"[Sender] Message sent: {TEST_MESSAGE}")
    producer.close()

def on_event(partition_context, event):
    print(f"[Receiver] Received: {event.body_as_str()}")
    partition_context.update_checkpoint(event)
    # Stop after receiving the first message
    receive_client.close()

def receive_messages():
    global receive_client
    print("[Receiver] Waiting for messages...")
    receive_client = EventHubConsumerClient.from_connection_string(
        CONNECTION_STR,
        CONSUMER_GROUP,
        eventhub_name=EVENTHUB_NAME
    )
    with receive_client:
        receive_client.receive(
            on_event=on_event,
            starting_position="-1",  # From beginning of stream
        )

if __name__ == "__main__":
    # Start receiver in a separate thread
    receiver_thread = threading.Thread(target=receive_messages)
    receiver_thread.start()

    # Delay to let receiver be ready
    time.sleep(2)

    # Send the message
    send_message()

    # Wait for receiver to complete
    receiver_thread.join()



# python eventhub_test.py
# [Receiver] Waiting for messages...
# [Sender] Connecting...
# [Sender] Message sent: Hello from private endpoint!
# [Receiver] Received: Hello from private endpoint!
# (eventhub-env) azureuser@linux-vm:~$ 