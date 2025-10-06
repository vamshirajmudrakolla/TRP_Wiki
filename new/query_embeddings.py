from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import HuggingFaceEmbeddings

# Load embeddings model
embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

# Load FAISS index (allow deserialization)
db = FAISS.load_local(
    "exstream_knowledge_index",
    embeddings,
    allow_dangerous_deserialization=True
)

# Query
query = "How do I migrate Exstream version 9 to version 16?"
results = db.similarity_search(query, k=3)

# Show results
print("\nTop results:\n")
for i, doc in enumerate(results):
    print(f"Result {i+1}:\n{doc.page_content}\n---")
