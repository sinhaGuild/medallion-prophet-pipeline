import confluent_kafka as ck
import requests
# /connector-plugins/{connectorType}/config/validate
import json

SOURCE_TOPICS = ["sales_database.public.sales_data_raw"]
SINK_TOPIC = "sales_data_enriched"

# # fields used to predict the price
# FIELDS = {
#     'enginesize':'engineSize',
#     'fueltype':'fuelType',
#     'mileage':'mileage',
#     'model':'model',
#     'mpg':'mpg',
#     'tax':'tax',
#     'transmission':'transmission',
#     'year':'year'
# }

PROPHET_API_URL = "http://fastapi:8000/predict"

if __name__ == "__main__":

    # Configure the consumer
    # to consume from the topic
    consumer = ck.Consumer(
        {
            "bootstrap.servers": "kafka:9092",
            "group.id": "engineer",
            "auto.offset.reset": "earliest",
        }
    )
    consumer.subscribe(SOURCE_TOPICS)
    
    producer = ck.Producer(
        {
            "bootstrap.servers": "broker:9092",
        }
    )

    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.value() is None:
            continue
        if msg.error():
            print("Consumer error: {}".format(msg.error()))
            continue

        # Retrieve the message and the key
        message = msg.value().decode("utf-8")
        key = msg.key().decode("utf-8")

        # load message as JSON
        json_message = json.loads(message)

        print(f"Extract timestamp from:{json_message}")
        
        # Create a new message with the fields used to predict the price
        # this message will be sent to the BentoML server
        ml_message = {
            field_name: json_message['payload'][field]
            for field, field_name 
            in FIELDS.items()
        }
        
        # Request the PROPHET_API deoloyed server to predict the price
        # and add the predicted price to the message
        response = requests.get(
            PROPHET_API_URL,
            json=ml_message
        )
        
        print(response.json())
        
        # Add the predicted price to the message
        json_message["payload"]["prediction"] = float(response.json())

        print("Consumed message")
        #pprint.pprint(json_message["payload"])
        print(json_message["payload"])
        
        # Send the message to the topic
        # with the predicted price
        producer.produce(
            SINK_TOPIC,
            key=key,
            value=json.dumps(json_message)
        )
        producer.flush()