from azure.servicebus import ServiceBusClient, ServiceBusMessage
import sys

# -----------------------------
# CONFIGURATION
# -----------------------------
CONNECTION_STR = "Endpoint=sb://abc-servicebus-namespace.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=rGOr4HNBTwuXnOOFGfrEnRSLzdBBhSXhA+ASbOdVRXY="
QUEUE_NAME = "abc-servicebus-queue"

# -----------------------------
# SEND MESSAGE FUNCTION
# -----------------------------
def send_message(servicebus_client, queue_name, message_text):
    sender = servicebus_client.get_queue_sender(queue_name=queue_name)
    with sender:
        message = ServiceBusMessage(message_text)
        sender.send_messages(message)
        print(f"✅ Sent message: {message_text}")

# -----------------------------
# RECEIVE MESSAGE FUNCTION
# -----------------------------
def receive_messages(servicebus_client, queue_name):
    receiver = servicebus_client.get_queue_receiver(queue_name=queue_name, max_wait_time=5)
    with receiver:
        for message in receiver:
            print(f"📥 Received message: {str(message)}")
            receiver.complete_message(message)

# -----------------------------
# MAIN EXECUTION
# -----------------------------
def main():
    if not CONNECTION_STR or not QUEUE_NAME:
        print("❌ ERROR: CONNECTION_STR and QUEUE_NAME must be set.")
        sys.exit(1)

    with ServiceBusClient.from_connection_string(conn_str=CONNECTION_STR) as client:
        print("🔗 Connected to Azure Service Bus")
        send_message(client, QUEUE_NAME, "Hello from anjali test script!")
        receive_messages(client, QUEUE_NAME)

if __name__ == "__main__":
    main()

# Output:
# (venv) user@ubuntu:~$ python3 test_servicebus.py
# 🔗 Connected to Azure Service Bus
# ✅ Sent message: Hello from structured test script!
# 📥 Received message: Hello from structured test script!