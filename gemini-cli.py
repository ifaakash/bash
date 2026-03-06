from google import genai

# client get the API Key from the GEMINI_API_KEY environment variable
client = genai.client()

prompt = input("Enter the question\n")

response = client.models.generate_content(
    model="gemini-3-flash-preview", content=prompt
)

print(response.text)
