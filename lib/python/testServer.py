import requests

# Send a GET request to the /hi endpoint
response = requests.get("http://localhost:1234/hi")
print(response.text)

# Send a GET request to the /numbers/12345 endpoint
response = requests.get("http://localhost:1234/numbers/12345")
print(response.text)

# Send a GET request to the /users/1 endpoint
response = requests.get("http://localhost:1234/users/1")
print(response.text)

# Send a GET request to the /body-header-param endpoint with a key query parameter
response = requests.get("http://localhost:1234/body-header-param", params={"key": "value"})
print(response.text)

# Send a GET request to the /stop endpoint to stop the server
response = requests.get("http://localhost:1234/stop")
