import google.generativeai as genai

genai.configure(api_key="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")

for model in genai.list_models():
    print(model.name)
