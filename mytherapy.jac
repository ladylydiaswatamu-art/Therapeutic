import from byllm.llm { Model}
import from dotenv { load_dotenv as ld}
import os;
 
def load_myapi_key_and_cache_it(){
     # Load variables from .env into the environment
    ld();
    # Retrieve the key
    api_key = os.getenv("GEMINI_API_KEYF");
    if not api_key{
        raise ValueError("GEMINI API KEY not available in .env file");
    }
        
    # Optionally cache it into the current terminal session
    os.environ["GEMINI_API_KEY"] = api_key;
    return api_key;
}
   