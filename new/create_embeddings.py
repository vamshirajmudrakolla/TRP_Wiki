from langchain.text_splitter import CharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import HuggingFaceEmbeddings
import os
import glob

# 1️⃣ Gather PDFs
docs_path = r"C:\Users\acer\Desktop\exstream_bot\docs\*.pdf"
pdf_files = glob.glob(docs_path)
if not pdf_files:
    raise ValueError("No .pdf files found in the 'docs/' folder.")

all_texts = []
for file_path in pdf_files:
    loader = PyPDFLoader(file_path)
    documents = loader.load()
    all_texts.extend(documents)

print(f"Loaded {len(all_texts)} documents.")

# 2️⃣ Split into chunks
text_splitter = CharacterTextSplitter(
    separator="\n",
    chunk_size=500,
    chunk_overlap=50
)
split_docs = text_splitter.split_documents(all_texts)
print(f"Split into {len(split_docs)} chunks.")

# 3️⃣ Initialize local embeddings (HuggingFace)
embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

# 4️⃣ Create FAISS vector store
db = FAISS.from_documents(split_docs, embeddings)

# 5️⃣ Save index
db.save_local("exstream_knowledge_index")

print("✅ Local embeddings created and FAISS index saved in 'exstream_knowledge_index'")
