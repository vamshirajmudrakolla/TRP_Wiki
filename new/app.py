import streamlit as st
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import HuggingFaceEmbeddings
from openai import OpenAI

# 1️⃣ Configure OpenRouter
client = OpenAI(
    api_key="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",
    base_url="https://openrouter.ai/api/v1"
)

# 2️⃣ Load embeddings
embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

# 3️⃣ Load FAISS index
db = FAISS.load_local(
    "exstream_knowledge_index",
    embeddings,
    allow_dangerous_deserialization=True
)

# 4️⃣ Streamlit UI config
st.set_page_config(page_title="Exstream Knowledge Assistant", page_icon="🔍", layout="wide")

# 5️⃣ Custom CSS for background and watermark
st.markdown(
    """
    <style>
    body {
        background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
        color: #f0f0f0;
    }
    .main {
        background-color: rgba(0,0,0,0);
    }
    .block-container {
        padding-top: 2rem;
    }
    h1, h2, h3, h4 {
        color: #ffffff;
    }
    .watermark {
        text-align: center;
        font-size: 0.85rem;
        color: #888888;
        margin-top: 50px;
    }
    </style>
    """,
    unsafe_allow_html=True
)

# 6️⃣ Page Header
st.markdown(
    """
    <h1 style='text-align: center;'>🔍 Exstream Knowledge Assistant</h1>
    <p style='text-align: center;'>Ask any question about <b>OpenText Exstream</b>, and I'll help you out!</p>
    """,
    unsafe_allow_html=True
)

# 7️⃣ Query Input
query = st.text_input(
    "💬 **Your question:**",
    placeholder="e.g., How do I create a composition in OpenText Exstream?"
)

# 8️⃣ Main Logic
if query:
    with st.spinner("🔍 Searching your documents..."):
        results = db.similarity_search_with_score(query, k=1)

    if results:
        doc, score = results[0]
        if score < 0.2:
            st.success("📘 **Answer from your uploaded documents:**")
            st.markdown(f"""
            <div style='border:1px solid #4CAF50; border-radius:8px; padding:1rem; background:#f6fdf6; color:#333;'>
            {doc.page_content}
            </div>
            """, unsafe_allow_html=True)
        else:
            st.info("✨ Mega is preparing your answer...")
            prompt = f"""
You are an expert on OpenText Exstream, the enterprise document composition software.
ONLY answer questions that are about OpenText Exstream or related concepts (such as composition center, delivery manager, workflows, templates, etc).
If the question is unrelated to OpenText Exstream, reply with: "I am sorry, but I can only answer questions about OpenText Exstream."

Question:
{query}
"""
            with st.spinner("✨ Mega is thinking..."):
                response = client.completions.create(
                    model="google/gemma-3n-e2b-it:free",
                    prompt=prompt,
                    max_tokens=1500,
                    stream=True
                )
                answer = ""
                response_box = st.empty()
                for chunk in response:
                    text_chunk = chunk.choices[0].text
                    answer += text_chunk
                    response_box.markdown(f"""
                    <div style='border:1px solid #2196F3; border-radius:8px; padding:1rem; background:#f0f7ff; color:#000;'>
                    {answer.strip()}
                    </div>
                    """, unsafe_allow_html=True)
    else:
        st.info("✨ Mega is preparing your answer...")
        prompt = f"""
You are an expert on OpenText Exstream, the enterprise document composition software.
ONLY answer questions that are about OpenText Exstream or related concepts (such as composition center, delivery manager, workflows, templates, etc).
If the question is unrelated to OpenText Exstream, reply with: "I am sorry, but I can only answer questions about OpenText Exstream."

Question:
{query}
"""
        with st.spinner("✨ Mega is thinking..."):
            response = client.completions.create(
                model="google/gemma-3n-e2b-it:free",
                prompt=prompt,
                max_tokens=1500,
                stream=True
            )
            answer = ""
            response_box = st.empty()
            for chunk in response:
                text_chunk = chunk.choices[0].text
                answer += text_chunk
                response_box.markdown(f"""
                <div style='border:1px solid #2196F3; border-radius:8px; padding:1rem; background:#f0f7ff; color:#000;'>
                {answer.strip()}
                </div>
                """, unsafe_allow_html=True)

# 9️⃣ Footer Watermark
st.markdown(
    """
    <div class='watermark'>Created by BhishmaCharya</div>
    """,
    unsafe_allow_html=True
)
